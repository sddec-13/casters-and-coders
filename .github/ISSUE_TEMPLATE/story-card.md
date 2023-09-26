---
name: Story Card
about: An outline for creating a good story card.
title: ''
labels: ''
assignees: ''

---

**Feature**
What is the feature you're adding? Give a brief description.

**Time Estimate**
How many hours of work do you expect this to take? It's ok to be wrong, just give it a guess. If your guess is greater than 15 or 20 hours, you should consider splitting this issue into smaller ones.

**Resources**
Link any relevant resources, documentation, google docs, etc. here. You'll be glad you did later.

**Acceptance Criteria**
How do we know that this issue is complete? It is essential to specify what constitutes "done". 

There's also a reason we use the plural "criteria" rather than the singular "criterion". Having multiple criteria, and even negative criteria (what should not happen) can help better define the feature.

A good acceptance criteria must also be testable. Something like "we need to have the movement be good enough" is an example of a criterion which is not testable.

When you're trying to write a criteria that's testable, it's often helpful to phrase things in terms of "Given x, when y, then z". So given x: some initial conditions, when y: something prompts your feature, then z: the desired outcome happens. This phrasing is not strictly necessary, especially for non-feature cards, but it is recommended to attempt to use it before going freestyle.

Here's an example of some criteria:
    Given a registered user with a valid account,
    When the user enters their correct username and password,
    Then they should be logged in successfully, and they should see their dashboard.

    Given a registered user with a valid account,
    When the user enters an incorrect password,
    Then they should see an error message indicating that the password is incorrect.

Given:

When:

Then:
