CREATE TABLE app_user (
    user_id SERIAL PRIMARY KEY,
    user_name VARCHAR(100) NOT NULL,
    age INTEGER CHECK (age > 0),
    emotional_state TEXT
);

ALTER TABLE app_user
    ADD CONSTRAINT chk_user_name_format
    CHECK (
        user_name ~ '^[A-Za-zА-Яа-яЁёІіЇїЄєҐґʼ\\-\\s]{2,100}$'
    );

CREATE TABLE daily_norm (
    daily_norm_id SERIAL PRIMARY KEY,
    volume_ml NUMERIC(8, 2) NOT NULL
        CHECK (volume_ml >= 0)
);

CREATE TABLE water_intake (
    water_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    intake_date DATE NOT NULL,
    amount_ml NUMERIC(8, 2) NOT NULL
        CHECK (amount_ml >= 0),
    daily_norm_id INTEGER,
    FOREIGN KEY (user_id)
        REFERENCES app_user (user_id)
        ON DELETE CASCADE,
    FOREIGN KEY (daily_norm_id)
        REFERENCES daily_norm (daily_norm_id)
        ON DELETE SET NULL
);

CREATE TABLE meditation (
    meditation_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    duration_min INTEGER CHECK (duration_min > 0)
);

CREATE TABLE meditation_usage (
    usage_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    meditation_id INTEGER NOT NULL,
    used_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (user_id)
        REFERENCES app_user (user_id)
        ON DELETE CASCADE,
    FOREIGN KEY (meditation_id)
        REFERENCES meditation (meditation_id)
        ON DELETE CASCADE
);

CREATE TABLE advice (
    advice_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    text TEXT NOT NULL,
    category VARCHAR(100),
    FOREIGN KEY (user_id)
        REFERENCES app_user (user_id)
        ON DELETE SET NULL
);

CREATE TABLE book (
    book_id SERIAL PRIMARY KEY,
    book_title VARCHAR(200) NOT NULL,
    author VARCHAR(150)
);

ALTER TABLE book
    ADD CONSTRAINT chk_book_title_format
    CHECK (
        book_title ~
        '^[A-Za-zА-Яа-я0-9\\s\\.,:;\\?\\!\\(\\)\\-]{1,200}$'
    );

CREATE TABLE book_recommendation (
    recommendation_id SERIAL PRIMARY KEY,
    user_id INTEGER,
    book_id INTEGER,
    reason TEXT,
    FOREIGN KEY (user_id)
        REFERENCES app_user (user_id)
        ON DELETE CASCADE,
    FOREIGN KEY (book_id)
        REFERENCES book (book_id)
        ON DELETE CASCADE
);

CREATE TABLE reading_journal (
    journal_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    book_id INTEGER NOT NULL,
    progress_pct INTEGER
        CHECK (progress_pct >= 0 AND progress_pct <= 100),
    entry_date DATE DEFAULT CURRENT_DATE,
    FOREIGN KEY (user_id)
        REFERENCES app_user (user_id)
        ON DELETE CASCADE,
    FOREIGN KEY (book_id)
        REFERENCES book (book_id)
        ON DELETE CASCADE
);

CREATE TABLE emotion_state (
    emotion_id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL,
    stress_level INTEGER
        CHECK (stress_level >= 1 AND stress_level <= 10),
    description TEXT,
    measured_at TIMESTAMP WITHOUT TIME ZONE DEFAULT NOW(),
    FOREIGN KEY (user_id)
        REFERENCES app_user (user_id)
        ON DELETE CASCADE
);
