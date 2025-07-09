# Readme

##


| Letter | Type | Description |
|--|--|--|
| S | String | Textual data, often used for names, titles, descriptions, etc. |
| N | Number | Numeric values (e.g. integers, floats); good for age, year, quantities. |
| F | Float | Specifically decimal numbers; sometimes used for prices or ratings. |
| B | Boolean | True/False values; handy for flags or binary states.|
| TS | Timestamp | Date/time values; useful for logging events or tracking updates. |
| U | Unique | Not a data type, but a constraint ensuring uniqueness across rows.|

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

