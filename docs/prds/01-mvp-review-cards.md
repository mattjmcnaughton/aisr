# PRD: MVP - Review Cards with Spaced Repetition

**Author:** Claude (AI Assistant)
**Date:** 2025-12-07
**Status:** Draft

## Problem Statement

Users who want to learn and retain information need a way to review flashcards using scientifically-proven spaced repetition scheduling. Without spaced repetition, learners either over-review (wasting time on cards they already know) or under-review (forgetting cards before they're reinforced). Currently, there is no application - users have no way to study flashcards with intelligent scheduling.

This is the MVP feature that establishes the core value proposition of AISR: effective learning through spaced repetition.

## Value Stream

| Metric | Current | Target | Measurement |
|--------|---------|--------|-------------|
| Cards reviewed per session | 0 (no app) | 20 | Analytics: `review_session_completed` event |
| Review session completion rate | N/A | 80% | Sessions completed / sessions started |
| Average session duration | N/A | 5-10 min | Timer from session start to completion |
| Cards due reviewed | N/A | 95% | Cards marked reviewed / cards presented |
| User retention (7-day) | N/A | 40% | Users returning within 7 days of first session |

## User Stories

### Story 1: Start a Review Session

As a learner,
I want to start a review session with cards due across my decks,
So that I can efficiently review what I need to without manually selecting cards.

**Acceptance Criteria:**
- [ ] User can start a review session from the main dashboard
- [ ] Session automatically includes cards due for review (next_review_at <= now)
- [ ] Cards are pulled from multiple decks the user has access to
- [ ] User can specify maximum number of cards to review (N)
- [ ] Default card limit is 20 cards
- [ ] Cards are prioritized by overdue time (most overdue first)

### Story 2: Review a Single Card

As a learner,
I want to see a card's front, reveal the back, and rate my recall,
So that the system can schedule my next review appropriately.

**Acceptance Criteria:**
- [ ] Card front is displayed initially
- [ ] User can reveal the back (click or keyboard shortcut)
- [ ] After revealing, user rates recall quality (1-4 scale: Again, Hard, Good, Easy)
- [ ] Rating advances to the next card immediately
- [ ] Keyboard shortcuts work for all actions (Space to flip, 1-4 to rate)
- [ ] Card content supports markdown rendering

### Story 3: Complete a Review Session

As a learner,
I want to see my session summary after completing reviews,
So that I can track my progress and feel accomplished.

**Acceptance Criteria:**
- [ ] Summary shows total cards reviewed
- [ ] Summary shows breakdown by rating (Again/Hard/Good/Easy counts)
- [ ] Summary shows session duration
- [ ] User can start another session or return to dashboard
- [ ] Session data is persisted for future analytics

### Story 4: Spaced Repetition Scheduling

As a learner,
I want my review ratings to affect when I see each card again,
So that I review difficult cards more often and easy cards less frequently.

**Acceptance Criteria:**
- [ ] "Again" (1): Card scheduled for ~1 minute (re-show in same session if possible, else next day)
- [ ] "Hard" (2): Card interval reduced or stays same, ease factor decreases
- [ ] "Good" (3): Card interval increases normally based on SM-2 algorithm
- [ ] "Easy" (4): Card interval increases significantly, ease factor increases
- [ ] New cards start with 1-day interval
- [ ] Minimum interval is 1 day (after session ends)
- [ ] Ease factor minimum is 1.3, default is 2.5

### Story 5: Filter by Deck (Optional)

As a learner,
I want to optionally review cards from specific decks only,
So that I can focus on a particular subject when needed.

**Acceptance Criteria:**
- [ ] User can select specific decks before starting session
- [ ] "All decks" is the default option
- [ ] Selected deck filter persists during session
- [ ] Multiple deck selection is supported

## Scope

### In Scope

**Backend:**
- User model (basic: id, email, created_at)
- Deck model (id, name, user_id, created_at)
- Card model (id, deck_id, front, back, created_at)
- CardSchedule model (card_id, next_review_at, interval, ease_factor, review_count)
- Review model (id, card_id, session_id, quality, reviewed_at)
- StudySession model (id, user_id, started_at, completed_at, cards_reviewed)
- SM-2 based spaced repetition algorithm in CardService
- REST API endpoints for:
  - `GET /api/v1/review/due` - Get cards due for review
  - `POST /api/v1/review/sessions` - Start a review session
  - `POST /api/v1/review/sessions/{id}/reviews` - Submit a card review
  - `PATCH /api/v1/review/sessions/{id}` - Complete a session
  - `GET /api/v1/decks` - List user's decks

**Frontend:**
- Review session page with card display
- Card flip animation
- Rating buttons (1-4)
- Session summary view
- Deck filter (optional multi-select)
- Keyboard navigation (Space, 1-4, arrow keys)
- Progress indicator during session

**Infrastructure:**
- PostgreSQL database schema
- Database migrations via Alembic

### Out of Scope

- User authentication/registration (assume single user or mock auth for MVP)
- Card creation/editing UI (seed data or API-only for MVP)
- Deck creation/management UI
- AI-powered card generation
- Statistics/analytics dashboard
- Mobile-responsive design (desktop-first for MVP)
- Offline support
- Card media (images, audio) - text only for MVP
- Card tags/labels
- Study reminders/notifications
- Import/export functionality
- Multiple users/sharing

## Technical Considerations

### API Changes

New endpoints required:

```
GET  /api/v1/decks
     Response: { data: Deck[], next_cursor?: string }

GET  /api/v1/review/due?limit=20&deck_ids=uuid,uuid
     Response: { data: Card[], total_due: number }

POST /api/v1/review/sessions
     Body: { deck_ids?: uuid[], card_limit?: number }
     Response: { id: uuid, cards: Card[], started_at: datetime }

POST /api/v1/review/sessions/{session_id}/reviews
     Body: { card_id: uuid, quality: 1|2|3|4 }
     Response: { next_review_at: datetime, new_interval: number }

PATCH /api/v1/review/sessions/{session_id}
     Body: { completed: true }
     Response: { summary: SessionSummary }
```

### Database Changes

New tables:
- `users` - Basic user info
- `decks` - Card collections
- `cards` - Flashcard content
- `card_schedules` - SRS scheduling data (1:1 with cards)
- `study_sessions` - Review session tracking
- `reviews` - Individual review records

Key indexes:
- `card_schedules.next_review_at` - For fetching due cards
- `cards.deck_id` - For deck filtering
- `reviews.session_id` - For session summary queries

### Dependencies

**Backend:**
- FastAPI (already planned)
- SQLModel (already planned)
- Alembic for migrations

**Frontend:**
- SWR for data fetching (already planned)
- Zustand for session state (already planned)
- Framer Motion or CSS transitions for card flip

### Performance Implications

- Due cards query should be efficient with proper indexing
- Consider caching due card count on dashboard
- Card flip should feel instant (<100ms)
- Review submission should be optimistic with background sync

## Design Requirements

### UI/UX

**Review Screen Layout:**
```
┌─────────────────────────────────────┐
│  [Progress: 5/20]      [End Early]  │
├─────────────────────────────────────┤
│                                     │
│                                     │
│         ┌───────────────┐           │
│         │               │           │
│         │  Card Front   │           │
│         │  or Back      │           │
│         │               │           │
│         └───────────────┘           │
│                                     │
│    [Click or Space to reveal]       │
│                                     │
├─────────────────────────────────────┤
│  [1:Again] [2:Hard] [3:Good] [4:Easy] │
└─────────────────────────────────────┘
```

**Design Principles (Linear-style):**
- Clean, minimal interface
- Dark mode by default
- Generous whitespace
- Subtle animations
- Focus on content, not chrome

### Keyboard Shortcuts

| Key | Action |
|-----|--------|
| Space | Flip card / Show answer |
| 1 | Rate: Again |
| 2 | Rate: Hard |
| 3 | Rate: Good |
| 4 | Rate: Easy |
| Escape | End session early |

### Accessibility

- All actions keyboard-accessible
- ARIA labels on interactive elements
- Sufficient color contrast
- Focus indicators visible
- Screen reader announces card content

## Risks

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| SM-2 algorithm edge cases cause poor scheduling | Medium | High | Comprehensive unit tests for algorithm, cap intervals at 365 days |
| Card flip animation feels janky | Low | Medium | Use CSS transforms with GPU acceleration, test on low-end devices |
| Large due queue causes slow page load | Low | Medium | Paginate due cards, lazy load card content |
| Users confused by rating scale | Medium | Medium | Add tooltip explanations, show next review date preview |
| Session state lost on refresh | Medium | High | Persist session to backend, resume capability |

## Rollout Plan

### Phase 1: Core Backend (Foundation)
- Database schema and migrations
- Core models (User, Deck, Card, CardSchedule)
- CardService with SM-2 algorithm
- Unit tests for scheduling logic

### Phase 2: API Layer
- Review endpoints
- Session management
- Integration tests

### Phase 3: Frontend MVP
- Review session flow
- Card display and flip
- Rating submission
- Session summary

### Phase 4: Polish
- Keyboard shortcuts
- Animations
- Error handling
- Loading states

### Rollback Strategy
- Feature flag: `ENABLE_REVIEW_SESSIONS`
- Can disable frontend route without backend changes
- Database migrations are additive (no destructive changes)

## Success Criteria

MVP is successful when:
1. A user can complete a 20-card review session end-to-end
2. Cards are rescheduled correctly based on ratings
3. Session summary displays accurate statistics
4. Keyboard-only navigation works for entire flow
5. P95 latency for card rating submission < 200ms

## Open Questions

1. Should "Again" cards re-appear in the same session or only next session?
   - **Recommendation:** Re-show at end of current session for better learning
2. What's the maximum interval cap?
   - **Recommendation:** 365 days to prevent cards from disappearing forever
3. Should we show the next review date after each rating?
   - **Recommendation:** Yes, as subtle feedback helps users understand the system
