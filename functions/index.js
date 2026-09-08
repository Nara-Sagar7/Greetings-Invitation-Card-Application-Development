/**
 * Greetings Cloud Functions - PRD 6.5 Sending + 6.2 RSVP automation
 * Email via SendGrid/SES, SPF/DKIM/DMARC required, Mail-Tester 9/10 gate
 */
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const sgMail = require('@sendgrid/mail');

admin.initializeApp();
const db = admin.firestore();

// Set via `firebase functions:config:set sendgrid.key="SG.xxx"`
try {
  const cfg = functions.config().sendgrid;
  if (cfg && cfg.key) sgMail.setApiKey(cfg.key);
} catch (_) {}

/**
 * Trigger on rsvp create - sends invitation email
 * Path: events/{eventId}/rsvps/{email}
 */
exports.sendInvitationEmail = functions.firestore
  .document('events/{eventId}/rsvps/{email}')
  .onCreate(async (snap, context) => {
    const { eventId, email } = context.params;
    const data = snap.data();
    const link = data.link || `https://greetings.app/rsvp/${eventId}?guest=${email}`;
    const eventSnap = await db.collection('events').doc(eventId).get();
    if (!eventSnap.exists) return null;
    // In production, fetch event details and send via SendGrid template
    const msg = {
      to: email,
      from: 'noreply@greetings.app', // must have SPF/DKIM/DMARC
      subject: `You're invited!`,
      text: `Hi ${data.name || ''}, you are invited! Open your card: ${link}`,
      html: `<p>Hi ${data.name || ''},</p><p>You are invited! <a href="${link}">View card & RSVP</a></p><img src="https://greetings.app/pixel/${eventId}/${encodeURIComponent(email)}.png" width="1" height="1"/>`,
    };
    if (!process.env.SENDGRID_KEY && !functions.config().sendgrid) {
      console.log('Mock email (no SendGrid key):', msg);
      return null;
    }
    try {
      await sgMail.send(msg);
      console.log(`Email sent to ${email} for ${eventId}`);
    } catch (e) {
      console.error('SendGrid failed', e);
    }
    return null;
  });

/**
 * Scheduled reminder 24h before event - single reminder per PRD 6.2
 * Configure via Cloud Scheduler: every hour check events where dateTime within 24h and reminder not sent
 */
exports.scheduledReminder = functions.pubsub.schedule('every 60 minutes').onRun(async () => {
  const now = admin.firestore.Timestamp.now();
  const in24h = admin.firestore.Timestamp.fromMillis(now.toMillis() + 24 * 60 * 60 * 1000);
  const q = await db.collectionGroup('events').where('dateTime', '>=', now).where('dateTime', '<=', in24h).where('reminderSent', '==', false).get();
  for (const doc of q.docs) {
    // In production, iterate guests and send reminder via rsvps subcollection
    await doc.ref.update({ reminderSent: true });
    console.log(`Reminder queued for ${doc.id}`);
  }
  return null;
});

/**
 * Pixel tracking for "opened" - PRD 6.3
 * HTTP endpoint: https://us-central1-greetings-world-atelier.cloudfunctions.net/trackOpen
 */
exports.trackOpen = functions.https.onRequest(async (req, res) => {
  const { eventId, email } = req.query;
  if (eventId && email) {
    await db.collection('events').doc(eventId).collection('opens').doc(email).set({ openedAt: admin.firestore.FieldValue.serverTimestamp() }, { merge: true });
  }
  // Return 1x1 transparent PNG
  const pixel = Buffer.from('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+ip1sAAAAASUVORK5CYII=', 'base64');
  res.set('Content-Type', 'image/png');
  res.send(pixel);
});
