# Rafael Jobsity Challenge

Rafael Ferraz Jobsity interview challenge

## Features Done(v)
- (v) List series with pagination.
- (v) Add search by name using appbar input.
- (v) Listing and search views show poster (no name, I know, but it was just terrible in the UI, sry).
- (v) After clicking on a series, shows all required fields, including episodes separated by season.
- (v) After clicking on an episode, shows all required fields too.

### Bonus Features Done(v)
- (v) Allow the user to set a PIN number. (Set once on installation only) .
- (v) For supported phones, fingerprint authentication to avoid typing the PIN number while opening the app.
- (v) Allow the user to save a series as a favorite.
- (v) Allow the user to browse their favorite series in alphabetical order, and click on one to see its details.
- (x) Create a people search by listing the name and image of the person.
- (V) After clicking on a person, the application should show required fields (not trough search, but from tv show cast member)

### Extra Features Done
- (v) Filter series, search result and favorites by genre (combined genre).
- (v) Show cast members image and names on Series information page.
- (v) UNIT TEST
- (v) Super good looking app

## Working process notes

The main focus is test driven development, using behavior (BDD) to fit the
application requirements.
TDD process lets you focus on domain (DDD), resulting in a better design, all together with tests quality assurance.
Event driven development fits perfectly with BDD language, making it easy to link code behavior
with document specified behaviors. Example:
- document says: 'When user taps...'
- code run: TapEvent trigger;
Not using fancy libs, all hand coded. Less dependency hell, and better control.


## Working process steps

- 1th:
  git init & first commit

- 2th:
  Started this documentation

- 3th:
  Sketch initial domain in order to accomplish first behavior, fetch series on start and test it.
  TDD & BDD

- 4th:
  Keep sketching domain in order to accomplish second behavior, search series.
  TDD & BDD

- 5th:
  Keep sketching domain in order to accomplish third behavior, series fields.
  TDD & BDD

- 6th:
  Keep sketching domain in order to accomplish fourth behavior, episode fields.
  TDD & BDD

- 7th:
  Enough sketching, now will start structure directories with clean arch

- 8th:
  Start basic home Ui

- 9th:
  Fetch data and bind data

- 10th
  Keep going until the end
