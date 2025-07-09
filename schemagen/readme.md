## Basic Flow
Prepare a Model File Structure each line using keywords like * for entities, PK for primary keys, FK for foreign keys, U for unique constraints, and one of S, N, F, B, or TS for attributes. Example:

    * Person
    PK id
    S name
    N age

## Example

    * Author
    PK id
    S name
    N birth_year

    * Book
    PK id
    S title
    FK author_id Author.id
    N published_year

