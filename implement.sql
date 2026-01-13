
CREATE TABLE Books (
    book_id INT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(100),
    total_copies INT NOT NULL DEFAULT 1,
    available_copies INT NOT NULL DEFAULT 1,
    CONSTRAINT chk_copies CHECK (available_copies <= total_copies AND available_copies >= 0)
);

CREATE TABLE Library_Users (
    user_id INT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    join_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE Issue_Records (
    issue_id SERIAL PRIMARY KEY,
    book_id INT REFERENCES Books(book_id) ON DELETE CASCADE,
    user_id INT REFERENCES Library_Users(user_id) ON DELETE CASCADE,
    issue_date DATE NOT NULL DEFAULT CURRENT_DATE,
    return_date DATE,
    CONSTRAINT chk_dates CHECK (return_date >= issue_date)
);


INSERT INTO Books (book_id, title, author, total_copies, available_copies) 
VALUES (101, 'The Great Gatsby', 'F. Scott Fitzgerald', 5, 5),
       (102, '1984', 'George Orwell', 10, 10);

INSERT INTO Library_Users (user_id, name, email) 
VALUES (501, 'Alice Vance', 'alice@email.com');


INSERT INTO Issue_Records (book_id, user_id, issue_date) VALUES (101, 501, CURRENT_DATE);
UPDATE Books SET available_copies = available_copies - 1 WHERE book_id = 101;


CREATE ROLE librarian WITH LOGIN PASSWORD 'LibPass123';
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO librarian;
REVOKE DELETE ON Books FROM librarian;