# Readme

## Attribute Types

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

## PlantUML Mapping

| Element | PlantUML | Equivalent | Notes |
|--|--|--|--|
| * EntityName | entity | EntityName { ... } | Declares an entity as a PlantUML class block |
| PK field | * field | inside the entity block | Rendered with a star to show it's a primary key |
| FK field | RefEntity.id | * field + relationship line | Field listed in entity, and a separate A::field -- B::id line |
| S, N, etc. | field or * field | based on nullability | Rendered normally or prefixed with * if not-null |
| Relationships | Entity::field -- OtherEntity::id | Drawn as connector lines in PlantUML output |

## Example
Given this schema input:

    * Author
    PK id
    S name
    N birth_year

    * Book
    PK id
    S title
    FK author_id Author.id

The generated PlantUML looks like:

    @startuml
    entity Author {
      * id
      --
      name
      birth_year
    }
    entity Book {
      * id
      --
      * author_id
      --
      title
    }
    Book::author_id -- Author::id
    @enduml

## SQLite Mapping

Input Model

    * Author
    PK id
    S name
    N birth_year

    * Book
    PK id
    S title
    FK author_id Author.id
    N published_year

Generated SQL Output

    CREATE TABLE Author (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      birth_year INTEGER
    );

    CREATE TABLE Book (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      author_id INTEGER NOT NULL,
      title TEXT,
      published_year INTEGER
    );

Note: Foreign keys are typed as INTEGER NOT NULL but not enforced as actual foreign key constraints—Sql.ls doesn’t emit FOREIGN KEY (...) REFERENCES ... clauses, just relational wiring for diagram purposes.
