INSERT INTO
    PARTAI_PESERTA_KOMPETISI (
        Jenis_Partai,
        Nama_Event,
        Tahun_Event,
        Nomor_Peserta
    )
VALUES
    ('MS', 'Indonesia Open', 2023, 1),
    ('MS', 'Indonesia Open', 2023, 2),
    ('MS', 'German Open', 2023, 5),
    ('MS', 'German Open', 2023, 6),
    ('WS', 'Indonesia Open', 2023, 3),
    ('WS', 'Indonesia Open', 2023, 4),
    ('WS', 'England Open', 2023, 7),
    ('WS', 'England Open', 2023, 8),
    ('WD', 'Indonesia Open', 2023, 15),
    ('WD', 'Indonesia Open', 2023, 16),
    ('WD', 'German Open', 2023, 15),
    ('WD', 'German Open', 2023, 16),
    ('MD', 'Indonesia Open', 2023, 13),
    ('MD', 'Indonesia Open', 2023, 14),
    ('MD', 'German Open', 2023, 13),
    ('MD', 'German Open', 2023, 14),
    ('XD', 'Indonesia Open', 2023, 9),
    ('XD', 'Indonesia Open', 2023, 10),
    ('XD', 'England Open', 2023, 11),
    ('XD', 'England Open', 2023, 12);

DELETE FROM PARTAI_PESERTA_KOMPETISI
WHERE
    Nama_Event = 'Indonesia Open'
    AND Tahun_Event = 2023
    AND Nomor_Peserta IN (
        (
            SELECT
                pk.Nomor_Peserta
            from
                PESERTA_KOMPETISI pk
                JOIN PARTAI_PESERTA_KOMPETISI ppk ON pk.Nomor_Peserta = ppk.Nomor_Peserta
            WHERE
                pk.ID_Atlet_Kualifikasi = '3e9f9238-6f5d-46af-b3e7-93ff56417ea6'
                AND ppk.nama_event = 'Indonesia Open'
                AND ppk.tahun_event = 2023
        )
        UNION
        (
            SELECT
                pk.Nomor_Peserta
            from
                PESERTA_KOMPETISI pk
                JOIN ATLET_GANDA ag ON pk.ID_Atlet_Ganda = AG.ID_Atlet_Ganda
                JOIN PARTAI_PESERTA_KOMPETISI ppk ON pk.Nomor_Peserta = ppk.Nomor_Peserta
            WHERE
                ag.ID_Atlet_Kualifikasi_2 = '3e9f9238-6f5d-46af-b3e7-93ff56417ea6'
                AND ppk.nama_event = 'Indonesia Open'
                AND ppk.tahun_event = 2023
        )
        UNION
        (
            SELECT
                pk.Nomor_Peserta
            from
                PESERTA_KOMPETISI pk
                JOIN ATLET_GANDA ag ON pk.ID_Atlet_Ganda = AG.ID_Atlet_Ganda
                JOIN PARTAI_PESERTA_KOMPETISI ppk ON pk.Nomor_Peserta = ppk.Nomor_Peserta
            WHERE
                ag.ID_Atlet_Kualifikasi = '3e9f9238-6f5d-46af-b3e7-93ff56417ea6'
                AND ppk.nama_event = 'Indonesia Open'
                AND ppk.tahun_event = 2023
        )
    );


    DELETE FROM PARTAI_PESERTA_KOMPETISI
WHERE
    Nama_Event = 'Indonesia Open'
    AND Tahun_Event = 2023
    AND Nomor_Peserta IN (
        (
            SELECT
                pk.Nomor_Peserta
            from
                PESERTA_KOMPETISI pk
                JOIN PARTAI_PESERTA_KOMPETISI ppk ON pk.Nomor_Peserta = ppk.Nomor_Peserta
            WHERE
                pk.ID_Atlet_Kualifikasi = '3e9f9238-6f5d-46af-b3e7-93ff56417ea6'
                AND ppk.nama_event = 'Indonesia Open'
                AND ppk.tahun_event = 2023
        )
        UNION
        (
            SELECT
                pk.Nomor_Peserta
            from
                PESERTA_KOMPETISI pk
                JOIN ATLET_GANDA ag ON pk.ID_Atlet_Ganda = AG.ID_Atlet_Ganda
                JOIN PARTAI_PESERTA_KOMPETISI ppk ON pk.Nomor_Peserta = ppk.Nomor_Peserta
            WHERE
                ag.ID_Atlet_Kualifikasi_2 = '3e9f9238-6f5d-46af-b3e7-93ff56417ea6'
                AND ppk.nama_event = 'Indonesia Open'
                AND ppk.tahun_event = 2023
        )
        UNION
        (
            SELECT
                pk.Nomor_Peserta
            from
                PESERTA_KOMPETISI pk
                JOIN ATLET_GANDA ag ON pk.ID_Atlet_Ganda = AG.ID_Atlet_Ganda
                JOIN PARTAI_PESERTA_KOMPETISI ppk ON pk.Nomor_Peserta = ppk.Nomor_Peserta
            WHERE
                ag.ID_Atlet_Kualifikasi = '3e9f9238-6f5d-46af-b3e7-93ff56417ea6'
                AND ppk.nama_event = 'Indonesia Open'
                AND ppk.tahun_event = 2023
        )
    );