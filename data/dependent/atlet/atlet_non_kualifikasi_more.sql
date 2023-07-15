-- Insert 10 members into the MEMBER table
INSERT INTO
    MEMBER (ID, Nama, Email)
VALUES
    (
        'b9f86f4d-82e0-4df0-b19f-14f369a00f5a',
        'John Doe',
        'john@example.com'
    ),
    (
        'a3b3a0a3-48d2-4c79-8a9a-5ac4a6ad2df2',
        'Jane Smith',
        'jane@example.com'
    ),
    (
        '268f7d0c-9a8e-4e7d-8b41-4fe49eae9a1f',
        'Michael Johnson',
        'michael@example.com'
    ),
    (
        'c2f8744e-c8f2-41d6-889d-1a9a805d7b12',
        'Emily Davis',
        'emily@example.com'
    ),
    (
        '3e9f9238-6f5d-46af-b3e7-93ff56417ea6',
        'David Lee',
        'david@example.com'
    ),
    (
        '5d49656a-9fc4-4b71-a8d4-77d1d70442d8',
        'Sarah Wilson',
        'sarah@example.com'
    ),
    (
        '8f7e6d5c-4b3a-486e-8aa5-9c8c3b2d1e0a',
        'Daniel Brown',
        'daniel@example.com'
    ),
    (
        'f6e5d4c3-b2a1-4d63-8e9b-0d2222a7a09e',
        'Jennifer Taylor',
        'jennifer@example.com'
    ),
    (
        'f662984a-4f0b-4b5a-8107-256b2ed6b5a9',
        'Andrew Clark',
        'andrew@example.com'
    ),
    (
        'e3d1c6f4-d4f0-4829-b633-84d2668cf3ba',
        'Olivia Allen',
        'olivia@example.com'
    );

INSERT INTO
    ATLET (
        ID,
        Tgl_Lahir,
        Negara_Asal,
        Play_Right,
        Height,
        World_Rank,
        Jenis_Kelamin
    )
VALUES
    (
        'b9f86f4d-82e0-4df0-b19f-14f369a00f5a',
        '1990-01-01',
        'United States',
        true,
        180,
        0,
        true
    ),
    (
        'a3b3a0a3-48d2-4c79-8a9a-5ac4a6ad2df2',
        '1991-02-02',
        'Canada',
        false,
        170,
        0,
        false
    ),
    (
        '268f7d0c-9a8e-4e7d-8b41-4fe49eae9a1f',
        '1992-03-03',
        'Australia',
        false,
        185,
        0,
        true
    ),
    (
        'c2f8744e-c8f2-41d6-889d-1a9a805d7b12',
        '1993-04-04',
        'Germany',
        false,
        175,
        0,
        false
    ),
    (
        '3e9f9238-6f5d-46af-b3e7-93ff56417ea6',
        '1994-05-05',
        'Brazil',
        false,
        190,
        0,
        true
    ),
    (
        '5d49656a-9fc4-4b71-a8d4-77d1d70442d8',
        '1995-06-06',
        'Japan',
        false,
        160,
        0,
        false
    ),
    (
        '8f7e6d5c-4b3a-486e-8aa5-9c8c3b2d1e0a',
        '1996-07-07',
        'France',
        false,
        195,
        0,
        true
    ),
    (
        'f6e5d4c3-b2a1-4d63-8e9b-0d2222a7a09e',
        '1997-08-08',
        'United Kingdom',
        false,
        165,
        0,
        false
    ),
    (
        'f662984a-4f0b-4b5a-8107-256b2ed6b5a9',
        '1998-09-09',
        'Italy',
        false,
        200,
        0,
        true
    ),
    (
        'e3d1c6f4-d4f0-4829-b633-84d2668cf3ba',
        '1999-10-10',
        'Spain',
        false,
        180,
        0,
        false
    );

INSERT INTO
    ATLET_KUALIFIKASI (ID_Atlet, World_Rank, World_Tour_Rank)
VALUES
    ('b9f86f4d-82e0-4df0-b19f-14f369a00f5a', 0, 0),
    ('a3b3a0a3-48d2-4c79-8a9a-5ac4a6ad2df2', 0, 0),
    ('268f7d0c-9a8e-4e7d-8b41-4fe49eae9a1f', 0, 0),
    ('c2f8744e-c8f2-41d6-889d-1a9a805d7b12', 0, 0),
    ('3e9f9238-6f5d-46af-b3e7-93ff56417ea6', 0, 0),
    ('5d49656a-9fc4-4b71-a8d4-77d1d70442d8', 0, 0),
    ('8f7e6d5c-4b3a-486e-8aa5-9c8c3b2d1e0a', 0, 0),
    ('f6e5d4c3-b2a1-4d63-8e9b-0d2222a7a09e', 0, 0),
    ('f662984a-4f0b-4b5a-8107-256b2ed6b5a9', 0, 0),
    ('e3d1c6f4-d4f0-4829-b633-84d2668cf3ba', 0, 0);

select
    ag.ID_Atlet_Ganda,
    ag.ID_Atlet_Kualifikasi,
    ag.ID_Atlet_Kualifikasi_2,
    SUM(ph.total_point) as total
from
    POINT_HISTORY ph
    join ATLET_GANDA ag on ph.id_atlet = ag.ID_Atlet_Kualifikasi
    or ph.id_atlet = ag.ID_Atlet_Kualifikasi_2
GROUP by
    ag.ID_Atlet_Ganda;