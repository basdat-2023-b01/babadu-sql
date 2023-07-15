CREATE SEQUENCE peserta_kompetisi_seq;

CREATE OR REPLACE FUNCTION assign_nomor_peserta()
  RETURNS TRIGGER AS $$
BEGIN
  NEW.Nomor_Peserta := nextval('peserta_kompetisi_seq');
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER assign_nomor_peserta_trigger
  BEFORE INSERT ON PESERTA_KOMPETISI
  FOR EACH ROW
  EXECUTE FUNCTION assign_nomor_peserta();
