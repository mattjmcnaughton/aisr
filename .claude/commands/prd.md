# Draft PRD

Create a Product Requirements Document for a new feature.

## Arguments
- $ARGUMENTS: Feature description or problem statement

## Process

1. **Understand the Problem**
   - What user problem does this solve?
   - Who experiences it?
   - How do they work around it today?

2. **Define Measurable Value**
   - What metrics will improve?
   - How will we measure success?
   - What are current vs target values?

3. **Research Codebase**
   - Explore relevant existing code
   - Identify integration points
   - Note technical constraints

4. **Draft PRD**
   Use the prd-author agent guidelines to create:
   - Problem statement
   - Value stream with metrics
   - User stories with acceptance criteria
   - Scope (in/out)
   - Technical considerations
   - Design requirements
   - Risks & mitigations
   - Rollout plan

## Output
Save PRD to `docs/prds/[feature-name].md`

## Template Location
See `.claude/agents/prd-author.md` for full template.

## Questions to Ask
Before drafting, clarify:
- Target users
- Success metrics preferences
- Timeline constraints
- Any known technical constraints
