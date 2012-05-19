create table posts (
    id integer,
    image blob,
    txt text not null,
    primary key (id)
);

create table threads (
    id integer,
    primary key (id)
);

create table replies (
    thread integer,
    reply integer,
    foreign key (thread) references threads(id),
    foreign key (reply) references posts(id)
);

