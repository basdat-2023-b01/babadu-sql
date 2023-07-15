CREATE OR REPLACE FUNCTION daftar_atlet_pelatih()
RETURNS TRIGGER AS $$
DECLARE
    athlete_exists BOOLEAN;
    coach_count INT;
BEGIN

    SELECT EXISTS (
        SELECT 1
        FROM atlet_pelatih
        WHERE id_pelatih = NEW.id_pelatih
        AND id_atlet = NEW.id_atlet
    ) INTO athlete_exists;

    IF athlete_exists THEN
        RETURN NULL;
    END IF;

    SELECT COUNT(*) INTO coach_count
    FROM atlet_pelatih
    WHERE id_atlet = NEW.id_atlet;

    IF coach_count >= 2 THEN
        DELETE FROM atlet_pelatih
        WHERE id_atlet = NEW.id_atlet
        AND id_pelatih IN (
            SELECT id_pelatih
            FROM atlet_pelatih
            WHERE id_atlet = NEW.id_atlet
            ORDER BY id_pelatih
            LIMIT 1
        );
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER daftar_atlet_pelatih_trigger
BEFORE INSERT ON atlet_pelatih
FOR EACH ROW
EXECUTE FUNCTION daftar_atlet_pelatih();