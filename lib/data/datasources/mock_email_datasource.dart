import '../../domain/entities/email.dart';
import '../../domain/entities/user.dart';

class MockEmailDatasource {
  static User get currentUser => const User(
        id: 'user_1',
        name: 'Ibrahim Mohammed Hassan',
        email: 'ibrahim@mailbox.com',
      );

  static List<Email> generateEmails() {
    final now = DateTime.now();
    return [
      Email(
        id: 'inbox_01',
        senderName: 'Google',
        senderEmail: 'no-reply@accounts.google.com',
        recipientEmail: 'ibrahim@mailbox.com',
        subject: 'Security alert: New sign-in on MacBook Pro',
        preview:
            'A new sign-in to your Google Account was detected from Lagos, Nigeria.',
        body:
            'Hi Ibrahim,\n\nYour Google Account (ibrahim@mailbox.com) was just signed in to from a new device.\n\nDevice: MacBook Pro\nLocation: Lagos, Nigeria\nTime: Just now\n\nIf this was you, you don\'t need to do anything. If you didn\'t sign in recently, we\'ll help you secure your account.\n\nThanks,\nThe Google Accounts team',
        timestamp: now.subtract(const Duration(minutes: 5)),
        isRead: false,
        folder: EmailFolder.inbox,
      ),
      Email(
        id: 'inbox_02',
        senderName: 'Figma',
        senderEmail: 'noreply@figma.com',
        recipientEmail: 'ibrahim@mailbox.com',
        subject: 'Fatima Aliyu shared "FinTech App Redesign" with you',
        preview: 'Fatima Aliyu has shared a Figma file with you.',
        body:
            'Hi Ibrahim,\n\nFatima Aliyu has shared the following Figma file with you:\n\n📐 FinTech App Redesign\n\nYou can now view and comment on this file. Click the link below to open it in Figma.\n\nOpen in Figma →\n\nHappy designing!\nThe Figma Team',
        timestamp: now.subtract(const Duration(hours: 1, minutes: 20)),
        isRead: false,
        isStarred: true,
        folder: EmailFolder.inbox,
      ),
      Email(
        id: 'inbox_03',
        senderName: 'GitHub',
        senderEmail: 'noreply@github.com',
        recipientEmail: 'ibrahim@mailbox.com',
        subject: '[fintech-app] Pull request merged: feat/mobile-payments (#31)',
        preview:
            'The pull request feat/mobile-payments has been merged into main.',
        body:
            'Hey @ibrahimhassan,\n\nThe pull request #31 "feat/mobile-payments" has been successfully merged into main.\n\nRepository: techteam-ng/fintech-app\nMerged by: fatima_dev\nCommits: 5 commits merged\n\nYou can view the full diff on GitHub.\n\nThe GitHub Team',
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: true,
        folder: EmailFolder.inbox,
      ),
      Email(
        id: 'inbox_04',
        senderName: 'Notion',
        senderEmail: 'no-reply@mail.notion.so',
        recipientEmail: 'ibrahim@mailbox.com',
        subject: 'Abdullahi invited you to collaborate on "Q2 Roadmap"',
        preview:
            'Abdullahi Musa has invited you to join the Q2 Roadmap workspace.',
        body:
            'Hi Ibrahim,\n\nAbdullahi Musa has invited you to collaborate on "Q2 Roadmap" in Notion.\n\nYou\'ve been given edit access to:\n• Q2 Product Roadmap\n• Sprint Planning Board\n• Design Review Notes\n\nOpen Notion →\n\nBest,\nThe Notion Team',
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: false,
        folder: EmailFolder.inbox,
      ),
      Email(
        id: 'inbox_05',
        senderName: 'Jumia',
        senderEmail: 'orders@jumia.com.ng',
        recipientEmail: 'ibrahim@mailbox.com',
        subject: 'Your Jumia order has shipped!',
        preview:
            'Great news! Your order #JUM-2094827 has shipped and is on its way.',
        body:
            'Hello Ibrahim,\n\nGreat news! Your Jumia order #JUM-2094827 has shipped!\n\nOrder Details:\n• Samsung Galaxy Buds2 Pro – ×1\n• Phone Case (Clear) – ×1\n\nExpected Delivery: Tomorrow by 6:00 PM\nDelivery Address: Victoria Island, Lagos\n\nYou can track your package using the link below.\n\nTrack Your Package →\n\nThank you for shopping with Jumia Nigeria.',
        timestamp: now.subtract(const Duration(hours: 8)),
        isRead: true,
        folder: EmailFolder.inbox,
      ),
      Email(
        id: 'inbox_06',
        senderName: 'Paystack',
        senderEmail: 'notifications@paystack.com',
        recipientEmail: 'ibrahim@mailbox.com',
        subject: 'Payment received: ₦75,000 from Acme Tech Ltd',
        preview: 'You received a payment of ₦75,000 from Acme Tech Ltd.',
        body:
            'Hi Ibrahim,\n\nYou\'ve received a payment!\n\nAmount: ₦75,000.00\nFrom: Acme Tech Ltd (acme@acmetech.ng)\nInvoice: INV-2025-0048\nDate: Today\n\nThe funds will be settled to your bank account within 1 business day.\n\nView payment details in your Paystack Dashboard →\n\nThe Paystack Team',
        timestamp: now.subtract(const Duration(hours: 11)),
        isRead: true,
        isStarred: true,
        folder: EmailFolder.inbox,
      ),
      Email(
        id: 'inbox_07',
        senderName: 'LinkedIn',
        senderEmail: 'messages-noreply@linkedin.com',
        recipientEmail: 'ibrahim@mailbox.com',
        subject: 'Usman Danladi viewed your profile',
        preview:
            'Your profile was viewed by Usman Danladi, Engineering Manager at Flutterwave.',
        body:
            'Hi Ibrahim,\n\nYour LinkedIn profile is getting noticed!\n\nUsman Danladi, Engineering Manager at Flutterwave viewed your profile.\n\nWith LinkedIn Premium, you can see everyone who\'s viewed your profile in the last 90 days.\n\nView Usman\'s profile →\n\nThe LinkedIn Team',
        timestamp: now.subtract(const Duration(days: 1, hours: 2)),
        isRead: false,
        folder: EmailFolder.inbox,
      ),
      Email(
        id: 'inbox_08',
        senderName: 'Zoom',
        senderEmail: 'no-reply@zoom.us',
        recipientEmail: 'ibrahim@mailbox.com',
        subject: 'Invitation: Daily Standup – Tomorrow at 9:00 AM WAT',
        preview: 'You have been invited to a Zoom meeting: Daily Standup.',
        body:
            'Hi Ibrahim,\n\nYou are invited to a Zoom meeting.\n\nMeeting: Daily Standup\nDate: Tomorrow\nTime: 9:00 AM – 9:15 AM WAT\nHost: Aisha Bello\n\nJoin Zoom Meeting →\nMeeting ID: 823 4567 8901\nPasscode: standup\n\nDial-in: +234 1 291 6750\n\nSee you there!\nAisha Bello',
        timestamp: now.subtract(const Duration(days: 1, hours: 6)),
        isRead: false,
        folder: EmailFolder.inbox,
      ),
      Email(
        id: 'inbox_09',
        senderName: 'MTN Nigeria',
        senderEmail: 'no-reply@mtn.com.ng',
        recipientEmail: 'ibrahim@mailbox.com',
        subject: 'Your MTN data bundle expires soon',
        preview:
            'Your 10GB data bundle expires in 2 days. Recharge now to stay connected.',
        body:
            'Dear Ibrahim,\n\nYour MTN data bundle is expiring soon.\n\nBundle: 10GB Monthly Plan\nData used: 8.4 GB\nData remaining: 1.6 GB\nExpiry: In 2 days\n\nRecharge options:\n• 1GB – ₦300\n• 3GB – ₦1,000\n• 10GB – ₦2,500\n• 20GB – ₦3,500\n\nDial *131# or visit the MyMTN app to buy a bundle.\n\nMTN – Everywhere You Go',
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
        folder: EmailFolder.inbox,
      ),
      Email(
        id: 'inbox_10',
        senderName: 'Flutterwave',
        senderEmail: 'no-reply@flutterwave.com',
        recipientEmail: 'ibrahim@mailbox.com',
        subject: 'You\'ve received ₦100,000 from Aisha Bello',
        preview:
            'Aisha Bello sent you ₦100,000. The money is in your Flutterwave account.',
        body:
            'Hi Ibrahim,\n\nGreat news — you\'ve received money!\n\nFrom: Aisha Bello (aisha@example.ng)\nAmount: ₦100,000.00\nNote: "For the freelance project — great work!"\n\nThis money is now in your Flutterwave balance. You can:\n• Transfer it to your bank account\n• Use it to pay bills\n• Send it to someone else\n\nView transaction →\n\nFlutterwave',
        timestamp: now.subtract(const Duration(days: 2, hours: 4)),
        isRead: true,
        folder: EmailFolder.inbox,
      ),
      Email(
        id: 'inbox_11',
        senderName: 'Slack',
        senderEmail: 'feedback@slack.com',
        recipientEmail: 'ibrahim@mailbox.com',
        subject: 'You have 9 unread messages in #general',
        preview:
            'Check what\'s been happening in your workspace while you were away.',
        body:
            'Hi Ibrahim,\n\nHere\'s what you missed in your workspace:\n\n📌 #general – 6 unread messages\nAbdullahi: "The new build is live on staging!"\nFatima: "Can someone review PR #32?"\n\n📌 #design – 3 unread messages\nAisha: "Updated the Figma components..."\n\nView all messages in Slack →\n\nThe Slack Team',
        timestamp: now.subtract(const Duration(days: 3)),
        isRead: true,
        folder: EmailFolder.inbox,
      ),
      Email(
        id: 'inbox_12',
        senderName: 'DStv Nigeria',
        senderEmail: 'info@dstv.com.ng',
        recipientEmail: 'ibrahim@mailbox.com',
        subject: 'Your DStv subscription renews in 3 days',
        preview:
            'Your Compact Plus subscription will renew on the 7th. Ensure your account is funded.',
        body:
            'Dear Ibrahim,\n\nThis is a reminder that your DStv subscription is due for renewal.\n\nPackage: Compact Plus\nRenewal Date: In 3 days\nAmount: ₦9,000/month\n\nHow to pay:\n• MyDStv App\n• USSD: *288#\n• Bank transfer\n\nEnsure your account is funded to avoid service interruption.\n\nFor support, call 09012345678.\n\nDStv Nigeria',
        timestamp: now.subtract(const Duration(days: 4)),
        isRead: true,
        folder: EmailFolder.inbox,
      ),
      Email(
        id: 'inbox_13',
        senderName: 'Boomplay',
        senderEmail: 'no-reply@boomplay.com',
        recipientEmail: 'ibrahim@mailbox.com',
        subject: 'Your Weekly Picks are ready 🎵',
        preview:
            'Your personalised playlist for this week is ready. Have a listen!',
        body:
            'Hi Ibrahim,\n\nYour Weekly Picks playlist has been updated with 20 new songs just for you.\n\nHighlights this week:\n• "Essence" – Wizkid ft. Tems\n• "Ye" – Burna Boy\n• "Sinner" – Omah Lay\n• "Peru" – Fireboy DML\n• "Location" – Davido\n\nListen to your Weekly Picks →\n\nBoomplay',
        timestamp: now.subtract(const Duration(days: 5)),
        isRead: true,
        folder: EmailFolder.inbox,
      ),
      Email(
        id: 'inbox_14',
        senderName: 'TechCabal',
        senderEmail: 'newsletter@techcabal.com',
        recipientEmail: 'ibrahim@mailbox.com',
        subject: 'This week in African tech: 5 stories you need to read',
        preview: 'Flutterwave expands to 12 new markets, and more top stories.',
        body:
            'Hi Ibrahim,\n\nHere are this week\'s top African tech stories:\n\n1. "Flutterwave expands payments to 12 new African markets"\n   6 min read · FinTech\n\n2. "Nigeria\'s startup ecosystem raises \$240M in Q1 2025"\n   8 min read · Startups\n\n3. "Paystack launches merchant credit product"\n   5 min read · FinTech\n\n4. "Meet the 10 Nigerian engineers shaping global tech"\n   10 min read · People\n\n5. "Building for Africa: Why local context matters in product design"\n   7 min read · Product\n\nRead on TechCabal →\n\nThe TechCabal Team',
        timestamp: now.subtract(const Duration(days: 6)),
        isRead: true,
        folder: EmailFolder.inbox,
      ),
      Email(
        id: 'inbox_15',
        senderName: 'Twitter / X',
        senderEmail: 'info@twitter.com',
        recipientEmail: 'ibrahim@mailbox.com',
        subject: 'You have 5 new notifications',
        preview:
            '@ibrahimhassan was mentioned in 3 tweets. See what people are saying.',
        body:
            'Hi Ibrahim,\n\nHere\'s what\'s happening on X:\n\n🔔 Notifications\n• @flutterng retweeted your post about mobile dev in Nigeria\n• @fatima_codes replied: "This thread is everything! 🙌"\n• @techcabal mentioned you in a thread about Nigerian devs\n• 38 new likes on your pinned post\n• 15 new followers this week\n\nSee all notifications →\n\nX (formerly Twitter)',
        timestamp: now.subtract(const Duration(days: 7)),
        isRead: true,
        folder: EmailFolder.inbox,
      ),

      Email(
        id: 'sent_01',
        senderName: 'Ibrahim Mohammed Hassan',
        senderEmail: 'ibrahim@mailbox.com',
        recipientEmail: 'manager@techhub.ng',
        subject: 'Weekly Progress Report – Week 14',
        preview:
            'Hi Fatima, please find below my weekly progress report for week 14.',
        body:
            'Hi Fatima,\n\nPlease find below my weekly progress report for Week 14.\n\n✅ Completed\n• Finished mobile payments module integration\n• Reviewed and merged 2 PRs from the team\n• Participated in design review with the UX team\n\n🔄 In Progress\n• Email detail screen UI implementation\n• Unit tests for repository layer\n\n🗓 Next Week\n• Complete compose screen\n• Integration testing with Paystack API\n• Code review for backend changes\n\nLet me know if you have any questions.\n\nBest regards,\nIbrahim Mohammed Hassan',
        timestamp: now.subtract(const Duration(days: 1, hours: 1)),
        isRead: true,
        folder: EmailFolder.sent,
      ),
      Email(
        id: 'sent_02',
        senderName: 'Ibrahim Mohammed Hassan',
        senderEmail: 'ibrahim@mailbox.com',
        recipientEmail: 'client@gbengaenterprises.ng',
        subject: 'Project Proposal: Mobile App Development',
        preview:
            'Dear Mr. Gbenga, I am pleased to submit our proposal for the mobile app project.',
        body:
            'Dear Mr. Gbenga,\n\nI am pleased to submit our proposal for the Mobile App Development project discussed in our meeting last Thursday.\n\nProject Overview:\n• Platform: iOS & Android (Flutter)\n• Timeline: 12 weeks\n• Budget: ₦18,000,000\n\nKey Deliverables:\n1. UI/UX Design (Week 1–2)\n2. Core Feature Development (Week 3–8)\n3. Testing & QA (Week 9–10)\n4. Deployment & Launch (Week 11–12)\n\nPlease review the attached detailed proposal and let me know if you have any questions.\n\nLooking forward to working with you.\n\nBest regards,\nIbrahim Mohammed Hassan',
        timestamp: now.subtract(const Duration(days: 3, hours: 5)),
        isRead: true,
        folder: EmailFolder.sent,
      ),
      Email(
        id: 'sent_03',
        senderName: 'Ibrahim Mohammed Hassan',
        senderEmail: 'ibrahim@mailbox.com',
        recipientEmail: 'team@techhub.ng',
        subject: 'Meeting Notes – Sprint Planning Q2',
        preview:
            'Hi team, here are the notes from today\'s sprint planning session.',
        body:
            'Hi team,\n\nHere are the key notes from today\'s Q2 Sprint Planning session:\n\nAttendees: Aisha, Abdullahi, Fatima, Usman, Ibrahim\n\nSprint Goals:\n• Launch v2.0 of the mobile payment app\n• Integrate Paystack and Flutterwave SDKs\n• Performance improvements (target: <2s load time)\n\nAction Items:\n• Aisha: Set up CI/CD pipeline by Friday\n• Abdullahi: Complete API documentation\n• Fatima: Finalise design assets\n• Ibrahim: Begin mobile app implementation\n\nNext meeting: Monday 9 AM WAT – Daily Standup\n\nFull notes are in Notion: [link]\n\nIbrahim',
        timestamp: now.subtract(const Duration(days: 5, hours: 3)),
        isRead: true,
        folder: EmailFolder.sent,
      ),
      Email(
        id: 'sent_04',
        senderName: 'Ibrahim Mohammed Hassan',
        senderEmail: 'ibrahim@mailbox.com',
        recipientEmail: 'hr@techhub.ng',
        subject: 'Annual Leave Request – April 15–19',
        preview:
            'Hi HR team, I\'d like to request annual leave for the week of April 15.',
        body:
            'Hi HR Team,\n\nI would like to formally request annual leave for the following dates:\n\nFrom: Monday, April 15, 2026\nTo: Friday, April 19, 2026\nTotal days: 5 working days\n\nReason: Family travel to Abuja (pre-planned)\n\nI have ensured that:\n• My current sprint tasks will be completed before my leave\n• Abdullahi has agreed to cover any urgent matters during my absence\n• All ongoing projects are documented and up to date\n\nPlease let me know if there are any issues with these dates.\n\nKind regards,\nIbrahim Mohammed Hassan',
        timestamp: now.subtract(const Duration(days: 8)),
        isRead: true,
        folder: EmailFolder.sent,
      ),
      Email(
        id: 'sent_05',
        senderName: 'Ibrahim Mohammed Hassan',
        senderEmail: 'ibrahim@mailbox.com',
        recipientEmail: 'support@interswitch.com',
        subject: 'Re: Account billing issue – Ticket #INS-4421',
        preview:
            'Hi support, following up on the billing discrepancy from last month.',
        body:
            'Hi Support Team,\n\nI am writing to follow up on ticket #INS-4421 regarding a billing discrepancy on my account.\n\nThe issue: I was charged ₦25,000 on March 1st for the Business plan, however I downgraded to the Starter plan (₦5,000) on February 15th.\n\nExpected charge: ₦5,000\nActual charge: ₦25,000\nDifference: ₦20,000\n\nI have attached the downgrade confirmation email and the billing statement for your reference.\n\nCould you please issue a refund of ₦20,000 to the original payment method?\n\nThank you for your help.\n\nBest regards,\nIbrahim Mohammed Hassan\nAccount: ibrahim@mailbox.com',
        timestamp: now.subtract(const Duration(days: 10)),
        isRead: true,
        folder: EmailFolder.sent,
      ),

      Email(
        id: 'draft_01',
        senderName: 'Ibrahim Mohammed Hassan',
        senderEmail: 'ibrahim@mailbox.com',
        recipientEmail: 'abdullahi@techhub.ng',
        subject: 'Follow up: Our meeting last week',
        preview:
            'Hi Abdullahi, I wanted to follow up on the discussion we had about the new payment architecture...',
        body:
            'Hi Abdullahi,\n\nI wanted to follow up on the discussion we had about the new payment integration architecture last week.\n\nAfter some further research, I think we should consider:\n\n1. Using Paystack\'s split payment API for the marketplace feature\n2. Adding Flutterwave as a fallback gateway\n3. ',
        timestamp: now.subtract(const Duration(hours: 4)),
        isRead: true,
        folder: EmailFolder.drafts,
      ),
      Email(
        id: 'draft_02',
        senderName: 'Ibrahim Mohammed Hassan',
        senderEmail: 'ibrahim@mailbox.com',
        recipientEmail: '',
        subject: '(No subject)',
        preview:
            'Quick reminder to myself: update the README before the demo on Friday...',
        body:
            'Quick reminder to myself: update the README before the demo on Friday. Also need to add screenshots and update the Paystack test keys.',
        timestamp: now.subtract(const Duration(days: 1, hours: 8)),
        isRead: true,
        folder: EmailFolder.drafts,
      ),
    ];
  }
}