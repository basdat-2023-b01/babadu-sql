CREATE OR REPLACE FUNCTION total_point_partai() RETURNS trigger AS
$$
DECLARE
    total_points INT;
    minimum_points INT;
BEGIN
    IF NEW.Jenis_Partai IN ('MD', 'WD', 'XD') THEN
        SELECT
            SUM(PH.Total_Point) AS Total_Point_Sum
            INTO total_points
        FROM
            POINT_HISTORY PH
            INNER JOIN ATLET_GANDA AG ON (
                PH.ID_Atlet = AG.ID_Atlet_Kualifikasi
                OR PH.ID_Atlet = AG.ID_Atlet_Kualifikasi_2
            )
        WHERE
            AG.ID_Atlet_Ganda IN (
                SELECT
                    ID_Atlet_Ganda
                FROM
                    PESERTA_KOMPETISI
                WHERE
                    Nomor_Peserta = NEW.Nomor_Peserta
            );
    ELSE
        SELECT
            SUM(PH.total_point) INTO total_points
        FROM
            POINT_HISTORY PH
            INNER JOIN PESERTA_KOMPETISI PK ON PH.ID_Atlet = PK.ID_Atlet_kualifikasi
        WHERE
            PK.Nomor_Peserta = NEW.Nomor_Peserta;
    END IF;

    SELECT
        CAST(SUBSTRING(E.kategori_superseries, 2) AS INT) * 0.5 INTO minimum_points
    FROM
        EVENT as E
    WHERE
        E.nama_event = NEW.nama_event
        AND E.tahun = NEW.tahun_event;

    IF Total_Points >= Minimum_Points THEN
        INSERT INTO PESERTA_MENDAFTAR_EVENT (Nomor_Peserta, Nama_Event, Tahun)
        SELECT NEW.Nomor_Peserta, NEW.Nama_Event, NEW.Tahun_Event
        WHERE NOT EXISTS (
            SELECT 1
            FROM PESERTA_MENDAFTAR_EVENT
            WHERE Nomor_Peserta = NEW.Nomor_Peserta
                AND Nama_Event = NEW.Nama_Event
                AND Tahun = NEW.Tahun_Event
        );
        RETURN NEW;
    ELSE
        RAISE EXCEPTION '[Peserta tidak memiliki poin yang cukup untuk mengikuti partai kompetisi di event ini. Point peserta saat ini adalah %, di mana partai kompetisi yang didaftar pada event ini memerlukan minimal point %]', Total_Points, Minimum_Points;
    END IF;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER total_point_partai
BEFORE INSERT ON PARTAI_PESERTA_KOMPETISI
FOR EACH ROW
EXECUTE FUNCTION total_point_partai();