create table users (
    id int auto_increment primary key,
    oauth_provider varchar(255) null comment 'Provider of OAuth, e.g., Google, Facebook',
    oauth_provider_id varchar(255) null comment 'Unique ID from the OAuth provider',
    email varchar(255) null comment 'Email provided by the OAuth provider',
    role varchar(255) null comment 'User roles such as admin, regular user',
    created_at timestamp default CURRENT_TIMESTAMP null,
    constraint email unique (email),
    constraint oauth_provider_id unique (oauth_provider_id)
);

create table goals (
    id int auto_increment primary key,
    user_id int null comment 'Foreign key to users table',
    title varchar(255) null comment 'Name of the goal',
    description text null comment 'Detailed description of the goal',
    start_date date null,
    end_date date null,
    status varchar(255) null comment 'Active, Completed, Archived',
    created_at timestamp default CURRENT_TIMESTAMP null,
    constraint fk_goals_user foreign key (user_id) references users (id)
);

create index user_id_idx on goals (user_id);

create table habits (
    id int auto_increment primary key,
    goal_id int null comment 'Foreign key to goals table',
    user_id int null comment 'Foreign key to users table',
    name varchar(255) null comment 'Name of the habit',
    frequency_type varchar(255) null comment 'Type of frequency: Daily, Weekly',
    frequency_details text null comment 'Details of the frequency. For daily, this could be empty. For weekly, specify days like "Mon, Wed, Fri"',
    duration int null comment 'Number of days for the habit (21-90 days)',
    notification_time time null comment 'Time of day to send notifications',
    created_at timestamp default CURRENT_TIMESTAMP null,
    status varchar(255) null comment 'Active, Skipped, Completed',
    constraint fk_habits_goal foreign key (goal_id) references goals (id),
    constraint fk_habits_user foreign key (user_id) references users (id)
);

create table habit_absences (
    id int auto_increment primary key,
    habit_id int null comment 'Foreign key to habits table',
    absence_date date null,
    reason text null comment 'Reason for skipping the habit',
    created_at timestamp default CURRENT_TIMESTAMP null,
    constraint fk_habit_absences_habit foreign key (habit_id) references habits (id)
);

create index habit_id_idx on habit_absences (habit_id);

create table habit_actions (
    id int auto_increment primary key,
    habit_id int null comment 'Foreign key to habits table',
    action_date date null comment 'Date of the action',
    action_text text null comment 'What user did',
    created_at timestamp default CURRENT_TIMESTAMP null,
    constraint fk_habit_actions_habit foreign key (habit_id) references habits (id)
);

create index habit_id_idx on habit_actions (habit_id);

create table habit_results (
    id int auto_increment primary key,
    action_id int null comment 'Foreign key to habit_actions table',
    result_text text null comment 'Result of the habit action',
    improvement_note text null comment 'User’s reflection on what was done well and what could be improved',
    created_at timestamp default CURRENT_TIMESTAMP null,
    constraint fk_habit_results_action foreign key (action_id) references habit_actions (id)
);

create index action_id_idx on habit_results (action_id);
create index goal_user_idx on habits (goal_id, user_id);

create table notifications (
    id int auto_increment primary key,
    user_id int null comment 'Foreign key to users table',
    habit_id int null comment 'Foreign key to habits table',
    notification_time timestamp null,
    status varchar(255) null comment 'Sent, Failed, Pending',
    created_at timestamp default CURRENT_TIMESTAMP null,
    constraint fk_notifications_habit foreign key (habit_id) references habits (id),
    constraint fk_notifications_user foreign key (user_id) references users (id)
);

create index user_habit_idx on notifications (user_id, habit_id);