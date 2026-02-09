# Task Breakdown: INIT-0001-example

## Task 1: Create Greeting Function

**Summary:** Implement a `greet(name)` function that returns a personalized greeting string.

**Steps:**
1. Create the source file
2. Implement the `greet` function with a `name` parameter
3. Handle edge cases (empty/missing name defaults to "World")

**Files Touched:**
- `src/greeting.py` (new)

**Acceptance Criteria:**
- `greet("Alice")` returns `"Hello, Alice!"`
- `greet("")` returns `"Hello, World!"`
- `greet()` returns `"Hello, World!"`

**Test Requirements:**
- Unit tests for each acceptance criterion
- Edge case tests for special characters in name

**Risk Level:** Low

**Dependencies:** None

---

## Task 2: Write Unit Tests

**Summary:** Create unit tests for the greeting function.

**Steps:**
1. Create the test file
2. Write tests for default greeting, named greeting, and edge cases
3. Verify all tests pass

**Files Touched:**
- `tests/test_greeting.py` (new)

**Acceptance Criteria:**
- All test cases pass
- Coverage includes default, named, and edge-case scenarios

**Test Requirements:**
- Minimum 3 test cases as defined above

**Risk Level:** Low

**Dependencies:** Task 1
