CREATE OR REPLACE FUNCTION unenroll_event() RETURNS trigger AS
$$
DECLARE
    event_start_date DATE;
    event_end_date DATE;
    current_date DATE := CURRENT_DATE;
BEGIN
    select 
    tgl_mulai, 
    tgl_selesai 
    INTO event_start_date, event_end_date
    FROM EVENT e WHERE e.nama_event = NEW.nama_event AND e.tahun = NEW.tahun;

    IF current_date BETWEEN event_end_date AND event_end_date  THEN
        RAISE EXCEPTION 'Tidak dapat mundur dari event karena event sudah dimulai';
    ELSE
        DELETE FROM PARTAI_PESERTA_KOMPETISI
        WHERE nomor_peserta = OLD.nomor_peserta
        AND nama_event = OLD.nama_event
        AND tahun_event = OLD.tahun;
        RETURN OLD;
    END IF;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER unenroll_event
BEFORE DELETE ON PESERTA_MENDAFTAR_EVENT
FOR EACH ROW
EXECUTE FUNCTION unenroll_event();