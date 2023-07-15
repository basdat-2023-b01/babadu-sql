-- assuming there no schema created yet
CREATE SCHEMA BABADU;

-- assuming search path is not set
SET
    SEARCH_PATH TO BABADU;

CREATE TABLE
    MEMBER (
        ID UUID PRIMARY KEY,
        Nama VARCHAR(50) NOT NULL,
        Email VARCHAR(50) NOT NULL
    );

CREATE TABLE
    UMPIRE (
        ID UUID PRIMARY KEY,
        Negara VARCHAR(50) NOT NULL,
        FOREIGN KEY (ID) REFERENCES MEMBER (ID)
    );

CREATE TABLE
    PELATIH (
        ID UUID PRIMARY KEY,
        Tanggal_Mulai DATE NOT NULL,
        FOREIGN KEY (ID) REFERENCES MEMBER (ID)
    );

CREATE TABLE
    SPESIALISASI (
        ID UUID PRIMARY KEY,
        Spesialisasi VARCHAR(20) NOT NULL
    );

CREATE TABLE
    PELATIH_SPESIALISASI (
        ID_Pelatih UUID,
        ID_Spesialisasi UUID,
        PRIMARY KEY (ID_Pelatih, ID_Spesialisasi),
        FOREIGN KEY (ID_Pelatih) REFERENCES PELATIH (ID),
        FOREIGN KEY (ID_Spesialisasi) REFERENCES SPESIALISASI (ID)
    );

CREATE TABLE
    ATLET (
        ID UUID PRIMARY KEY,
        MEMBER_ID UUID REFERENCES MEMBER (ID),
        Tgl_Lahir DATE NOT NULL,
        Negara_Asal VARCHAR(50) NOT NULL,
        Play_Right BOOLEAN NOT NULL,
        Height INT NOT NULL,
        World_Rank INT,
        Jenis_Kelamin BOOLEAN NOT NULL
    );

CREATE TABLE
    ATLET_PELATIH (
        ID_Pelatih UUID,
        ID_Atlet UUID,
        PRIMARY KEY (ID_Pelatih, ID_Atlet),
        FOREIGN KEY (ID_Pelatih) REFERENCES PELATIH (ID),
        FOREIGN KEY (ID_Atlet) REFERENCES ATLET (ID)
    );

CREATE TABLE
    SPONSOR (
        ID UUID PRIMARY KEY,
        Nama_Brand VARCHAR(50) NOT NULL,
        Website VARCHAR(50),
        CP_Name VARCHAR(50) NOT NULL,
        CP_Email VARCHAR(50) NOT NULL
    );

CREATE TABLE
    ATLET_SPONSOR (
        ID_Atlet UUID,
        ID_Sponsor UUID,
        Tgl_Mulai DATE NOT NULL,
        Tgl_Selesai DATE,
        PRIMARY KEY (ID_Atlet, ID_Sponsor),
        FOREIGN KEY (ID_Atlet) REFERENCES ATLET (ID),
        FOREIGN KEY (ID_Sponsor) REFERENCES SPONSOR (ID)
    );

CREATE TABLE
    ATLET_KUALIFIKASI (
        ID_Atlet UUID PRIMARY KEY,
        World_Rank INT,
        World_Tour_Rank INT NOT NULL,
        FOREIGN KEY (ID_Atlet) REFERENCES ATLET (ID)
    );

CREATE TABLE
    ATLET_NON_KUALIFIKASI (
        ID_Atlet UUID PRIMARY KEY,
        FOREIGN KEY (ID_Atlet) REFERENCES ATLET (ID)
    );

CREATE TABLE
    UJIAN_KUALIFIKASI (
        Tahun INT,
        Batch INT,
        Tempat VARCHAR(50),
        Tanggal DATE,
        PRIMARY KEY (Tahun, Batch, Tempat, Tanggal)
    );

CREATE TABLE
    ATLET_NONKUALIFIKASI_UJIAN_KUALIFIKASI (
        ID_Atlet UUID,
        Tahun INT,
        Batch INT,
        Tempat VARCHAR(50),
        Tanggal DATE,
        Hasil_Lulus BOOLEAN,
        PRIMARY KEY (
            ID_Atlet,
            Tahun,
            Batch,
            Tempat,
            Tanggal,
            Hasil_Lulus
        ),
        FOREIGN KEY (ID_Atlet) REFERENCES ATLET_NON_KUALIFIKASI (ID_Atlet),
        FOREIGN KEY (Tahun, Batch, Tempat, Tanggal) REFERENCES UJIAN_KUALIFIKASI (Tahun, Batch, Tempat, Tanggal)
    );

CREATE TABLE
    ATLET_GANDA (
        ID_Atlet_Ganda UUID PRIMARY KEY,
        ID_Atlet_Kualifikasi UUID REFERENCES ATLET_KUALIFIKASI (ID_Atlet),
        ID_Atlet_Kualifikasi_2 UUID REFERENCES ATLET_KUALIFIKASI (ID_Atlet)
    );

CREATE TABLE
    STADIUM (
        Nama VARCHAR(50) PRIMARY KEY,
        Alamat VARCHAR(50) NOT NULL,
        Kapasitas INT NOT NULL,
        Negara VARCHAR(50) NOT NULL,
        CONSTRAINT kelipatah_dua CHECK (MOD(Kapasitas, 2) = 0)
    );

CREATE TABLE
    EVENT (
        Nama_Event VARCHAR(50),
        Tahun INT,
        Nama_Stadium VARCHAR(50),
        Negara VARCHAR(50) NOT NULL,
        Tgl_Mulai DATE NOT NULL,
        Tgl_Selesai DATE NOT NULL,
        Kategori_Superseries VARCHAR(5) NOT NULL,
        Total_Hadiah BIGINT,
        PRIMARY KEY (Nama_Event, Tahun),
        FOREIGN KEY (Nama_Stadium) REFERENCES STADIUM (Nama)
    );

CREATE TABLE
    PESERTA_KOMPETISI (
        Nomor_Peserta INT PRIMARY KEY,
        ID_Atlet_Ganda UUID,
        ID_Atlet_Kualifikasi UUID,
        World_Rank INT,
        World_Tour_Rank INT NOT NULL,
        FOREIGN KEY (ID_Atlet_Ganda) REFERENCES ATLET_GANDA (ID_Atlet_Ganda),
        FOREIGN KEY (ID_Atlet_Kualifikasi) REFERENCES ATLET_KUALIFIKASI (ID_Atlet)
    );

CREATE SEQUENCE peserta_kompetisi_nomor_peserta_seq;

ALTER TABLE PESERTA_KOMPETISI
ALTER COLUMN Nomor_Peserta
SET DEFAULT nextval ('peserta_kompetisi_nomor_peserta_seq');

CREATE TABLE
    PARTAI_KOMPETISI (
        Jenis_Partai CHAR(2),
        Nama_Event VARCHAR(50),
        Tahun_Event INT,
        PRIMARY KEY (Jenis_Partai, Nama_Event, Tahun_Event),
        FOREIGN KEY (Nama_Event, Tahun_Event) REFERENCES EVENT (Nama_Event, Tahun)
    );

CREATE TABLE
    PARTAI_PESERTA_KOMPETISI (
        Jenis_Partai CHAR(2),
        Nama_Event VARCHAR(50),
        Tahun_Event INT,
        Nomor_Peserta INT,
        PRIMARY KEY (
            Jenis_Partai,
            Nama_Event,
            Tahun_Event,
            Nomor_Peserta
        ),
        FOREIGN KEY (Jenis_Partai, Nama_Event, Tahun_Event) REFERENCES PARTAI_KOMPETISI (Jenis_Partai, Nama_Event, Tahun_Event),
        FOREIGN KEY (Nomor_Peserta) REFERENCES PESERTA_KOMPETISI (Nomor_Peserta)
    );

CREATE TABLE
    PESERTA_MENDAFTAR_EVENT (
        Nomor_Peserta INT,
        Nama_Event VARCHAR(50),
        Tahun INT,
        PRIMARY KEY (Nomor_Peserta, Nama_Event, Tahun),
        FOREIGN KEY (Nomor_Peserta) REFERENCES PESERTA_KOMPETISI (Nomor_Peserta),
        FOREIGN KEY (Nama_Event, Tahun) REFERENCES EVENT (Nama_Event, Tahun)
    );

CREATE TABLE
    MATCH (
        Jenis_Babak VARCHAR(20) NOT NULL,
        Tanggal DATE NOT NULL,
        Tahun_Event INT,
        Waktu_Mulai TIME NOT NULL,
        Total_Durasi INT NOT NULL,
        Nama_Event VARCHAR(50),
        ID_Umpire UUID,
        PRIMARY KEY (Jenis_Babak, Tanggal, Waktu_Mulai),
        FOREIGN KEY (Nama_Event, Tahun_Event) REFERENCES EVENT (Nama_Event, Tahun),
        FOREIGN KEY (ID_Umpire) REFERENCES UMPIRE (ID)
    );

CREATE TABLE
    PESERTA_MENGIKUTI_MATCH (
        Jenis_Babak VARCHAR(20) NOT NULL,
        Tanggal DATE NOT NULL,
        Waktu_Mulai TIME NOT NULL,
        Nomor_Peserta INT NOT NULL,
        Status_Menang BOOLEAN NOT NULL,
        PRIMARY KEY (Jenis_Babak, Tanggal, Waktu_Mulai, Nomor_Peserta),
        FOREIGN KEY (Jenis_Babak, Tanggal, Waktu_Mulai) REFERENCES MATCH (Jenis_Babak, Tanggal, Waktu_Mulai),
        FOREIGN KEY (Nomor_Peserta) REFERENCES PESERTA_KOMPETISI (Nomor_Peserta)
    );

CREATE TABLE
    GAME (
        No_Game INT PRIMARY KEY,
        Durasi INT NOT NULL,
        Jenis_Babak VARCHAR(20),
        Tanggal DATE,
        Waktu_Mulai TIME,
        FOREIGN KEY (Jenis_Babak, Tanggal, Waktu_Mulai) REFERENCES MATCH (Jenis_Babak, Tanggal, Waktu_Mulai)
    );

CREATE TABLE
    PESERTA_MENGIKUTI_GAME (
        Nomor_Peserta INT,
        No_Game INT,
        Skor INT NOT NULL,
        PRIMARY KEY (Nomor_Peserta, No_Game),
        FOREIGN KEY (Nomor_Peserta) REFERENCES PESERTA_KOMPETISI (Nomor_Peserta),
        FOREIGN KEY (No_Game) REFERENCES GAME (No_Game)
    );

CREATE TABLE
    POINT_HISTORY (
        ID_Atlet UUID,
        Minggu_Ke INT NOT NULL,
        Bulan VARCHAR(20) NOT NULL,
        Tahun INT NOT NULL,
        Total_Point INT,
        PRIMARY KEY (ID_Atlet, Minggu_Ke, Bulan, Tahun),
        FOREIGN KEY (ID_Atlet) REFERENCES ATLET (ID)
    );

-- init table state
INSERT INTO
    MEMBER (id, nama, email)
VALUES
    (
        '4db94ea8-c5e1-40aa-97a5-3eb6d44f2811',
        'Niles Pengilly',
        'npengilly0@weibo.com'
    ),
    (
        'c4089711-83bd-496d-a2ea-8de1b77669be',
        'Aloysius Texton',
        'atexton1@51.la'
    ),
    (
        '96c72405-64c4-4346-9bf2-9ea6143b6b2b',
        'Ardith Hebner',
        'ahebner2@printfriendly.com'
    ),
    (
        '1dd27b2d-e148-412a-8574-4c7b85199d83',
        'Felike Tathacott',
        'ftathacott3@hp.com'
    ),
    (
        '0c9e02f1-766a-4ef8-8cc1-ea1684a0f41e',
        'Raphael Wagge',
        'rwagge4@wordpress.com'
    ),
    -- pelatih
    (
        '29e88a08-e0ce-4983-8d2f-273c8f6f0c99',
        'Marv Yakebowitch',
        'myakebowitch5@youku.com'
    ),
    (
        '04aa6c0e-1c68-42c1-a5c0-28db4faf03e6',
        'Carola Eschalotte',
        'ceschalotte6@technorati.com'
    ),
    (
        '20a5180f-dbfb-49f6-8628-d3a3b9104be4',
        'Guthrey Crolla',
        'gcrolla7@prweb.com'
    ),
    (
        'c8f18478-7bf8-42d3-b913-84aa136df0e3',
        'Gussy Capeling',
        'gcapeling8@ocn.ne.jp'
    ),
    (
        'fd502975-4ebe-43e2-bb2e-5c11b931a208',
        'Peg Davidesco',
        'pdavidesco9@noaa.gov'
    ),
    -- atlet
    (
        'ed9c30c2-33fe-44ea-9bbe-dd79d1c495c1',
        'Marcus Fernaldi Gideon',
        'marcusfernaldi@gmail.com'
    ),
    (
        'd0e4990c-c628-45b8-b0f2-064e8d26e048',
        'Kevin Sanjaya Sukamuljo',
        'kevin.sanjaya19@yahoo.com'
    ),
    (
        '67296d7a-2989-42cb-bae3-08b92c30263b',
        'Kento Momota ',
        'kento.mamota@bing.com'
    ),
    (
        '3484fd6a-19bc-4758-b503-614ccf2a8c35',
        'Anthony Sinisuka Ginting',
        'anthony.sinisuka@gmail.com'
    ),
    (
        '5f1ee424-a18c-46f6-a706-4d13b741612e',
        'Akane Yamaguchi',
        'akane.yamaguchi@gmail.com'
    ),
    (
        '6e256d6a-df83-4aa4-832f-17dc0558610a',
        'Crissy Staterfield',
        'cstaterfieldf@cbslocal.com'
    ),
    (
        'af9c7852-89ba-4059-93b0-7712e8139b76',
        'Fransisco Caneo',
        'fcaneog@people.com.cn'
    ),
    (
        '526a7450-211e-41ce-bcc7-59bcafe8ab03',
        'Maritsa Featherstonehaugh',
        'mfeatherstonehaughh@google.co.uk'
    ),
    (
        '06527cb8-e5cb-4839-b536-b6f73a9650f9',
        'Lorri Rowthorn',
        'lrowthorni@blogtalkradio.com'
    ),
    (
        '7074aef6-8cf0-4da3-9852-0b16caf15afd',
        'Jereme Dayton',
        'jdaytonj@vk.com'
    ),
    (
        '71b31d77-4c9e-4b71-bbc4-bdf65019b659',
        'Geordie Tremathack',
        'gtremathackk@istockphoto.com'
    ),
    (
        'f0cf3333-c33c-41d3-aaf6-6292054f66f8',
        'Linnie Oldham',
        'loldhaml@ycombinator.com'
    ),
    (
        'bf17ba0d-c786-470d-980d-21c4d48f680e',
        'Harriett Vasnev',
        'hvasnevm@cmu.edu'
    ),
    (
        'f3174adc-cf10-4e8c-9131-5ab7d3c3a38e',
        'Carine Penelli',
        'cpenellin@clickbank.net'
    ),
    (
        'f24db237-4fb9-466c-a19e-dfd32ae03718',
        'Deeanne Boullen',
        'dboulleno@jalbum.net'
    );

INSERT INTO
    UMPIRE (ID, Negara)
VALUES
    (
        '4db94ea8-c5e1-40aa-97a5-3eb6d44f2811',
        'Indonesia'
    ),
    (
        'c4089711-83bd-496d-a2ea-8de1b77669be',
        'Korea Selatan'
    ),
    ('96c72405-64c4-4346-9bf2-9ea6143b6b2b', 'Jerman'),
    ('1dd27b2d-e148-412a-8574-4c7b85199d83', 'Jepang'),
    (
        '0c9e02f1-766a-4ef8-8cc1-ea1684a0f41e',
        'Amerika Serikat'
    );

INSERT INTO
    PELATIH (ID, Tanggal_Mulai)
VALUES
    (
        '29e88a08-e0ce-4983-8d2f-273c8f6f0c99',
        '2022-01-01'
    ),
    (
        '04aa6c0e-1c68-42c1-a5c0-28db4faf03e6',
        '2022-01-02'
    ),
    (
        '20a5180f-dbfb-49f6-8628-d3a3b9104be4',
        '2022-01-03'
    ),
    (
        'c8f18478-7bf8-42d3-b913-84aa136df0e3',
        '2022-01-04'
    ),
    (
        'fd502975-4ebe-43e2-bb2e-5c11b931a208',
        '2022-01-05'
    );

INSERT INTO
    SPESIALISASI (ID, Spesialisasi)
VALUES
    (
        '83a91d0c-58f3-4763-b6f9-2a9a8bb74e2e',
        'Teknik Smash'
    ),
    (
        'b71e0908-63a7-4d84-9cb9-8a372f758c0e',
        'Teknik Netting'
    ),
    (
        '4e4c4b4a-774b-4e9f-8ab3-3e534f90b0d2',
        'Teknik Servis'
    ),
    (
        'a4e205fc-33c4-4d38-a77d-0c5a8af0d5c5',
        'Teknik Drop Shot'
    ),
    (
        '453ae9c9-c8e4-4a4d-99f5-56c5d2e5e5f5',
        'Teknik Lob'
    );

INSERT INTO
    PELATIH_SPESIALISASI (ID_Pelatih, ID_Spesialisasi)
VALUES
    (
        '29e88a08-e0ce-4983-8d2f-273c8f6f0c99',
        '83a91d0c-58f3-4763-b6f9-2a9a8bb74e2e'
    ),
    (
        '29e88a08-e0ce-4983-8d2f-273c8f6f0c99',
        'b71e0908-63a7-4d84-9cb9-8a372f758c0e'
    ),
    (
        '04aa6c0e-1c68-42c1-a5c0-28db4faf03e6',
        '4e4c4b4a-774b-4e9f-8ab3-3e534f90b0d2'
    ),
    (
        '04aa6c0e-1c68-42c1-a5c0-28db4faf03e6',
        'a4e205fc-33c4-4d38-a77d-0c5a8af0d5c5'
    ),
    (
        '20a5180f-dbfb-49f6-8628-d3a3b9104be4',
        '453ae9c9-c8e4-4a4d-99f5-56c5d2e5e5f5'
    ),
    (
        '20a5180f-dbfb-49f6-8628-d3a3b9104be4',
        '83a91d0c-58f3-4763-b6f9-2a9a8bb74e2e'
    ),
    (
        'c8f18478-7bf8-42d3-b913-84aa136df0e3',
        'b71e0908-63a7-4d84-9cb9-8a372f758c0e'
    ),
    (
        'c8f18478-7bf8-42d3-b913-84aa136df0e3',
        '4e4c4b4a-774b-4e9f-8ab3-3e534f90b0d2'
    ),
    (
        'fd502975-4ebe-43e2-bb2e-5c11b931a208',
        'a4e205fc-33c4-4d38-a77d-0c5a8af0d5c5'
    ),
    (
        'fd502975-4ebe-43e2-bb2e-5c11b931a208',
        '453ae9c9-c8e4-4a4d-99f5-56c5d2e5e5f5'
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
        'ed9c30c2-33fe-44ea-9bbe-dd79d1c495c1',
        '1998-05-01',
        'Indonesia',
        true,
        175,
        10,
        true
    ),
    (
        'd0e4990c-c628-45b8-b0f2-064e8d26e048',
        '1997-06-02',
        'Indonesia',
        true,
        180,
        5,
        true
    ),
    (
        '67296d7a-2989-42cb-bae3-08b92c30263b',
        '1999-07-03',
        'Indoneisa',
        false,
        178,
        15,
        false
    ),
    (
        '3484fd6a-19bc-4758-b503-614ccf2a8c35',
        '1996-08-04',
        'Indonesia',
        true,
        185,
        3,
        false
    ),
    (
        '5f1ee424-a18c-46f6-a706-4d13b741612e',
        '1995-09-05',
        'Jerman',
        false,
        182,
        7,
        true
    ),
    (
        '6e256d6a-df83-4aa4-832f-17dc0558610a',
        '1994-10-06',
        'Jerman',
        true,
        190,
        2,
        true
    ),
    (
        'af9c7852-89ba-4059-93b0-7712e8139b76',
        '1993-11-07',
        'Jerman',
        true,
        176,
        8,
        false
    ),
    (
        '526a7450-211e-41ce-bcc7-59bcafe8ab03',
        '1992-12-08',
        'Jerman',
        false,
        181,
        6,
        false
    ),
    -- non kualifikasi di bawah
    (
        '06527cb8-e5cb-4839-b536-b6f73a9650f9',
        '1991-01-09',
        'Rusia',
        true,
        177,
        12,
        true
    ),
    (
        '7074aef6-8cf0-4da3-9852-0b16caf15afd',
        '1990-02-10',
        'Italia',
        false,
        183,
        9,
        true
    ),
    (
        '71b31d77-4c9e-4b71-bbc4-bdf65019b659',
        '1989-03-11',
        'Belanda',
        true,
        179,
        4,
        true
    ),
    (
        'f0cf3333-c33c-41d3-aaf6-6292054f66f8',
        '1988-04-12',
        'Spanyol',
        true,
        174,
        11,
        true
    ),
    (
        'bf17ba0d-c786-470d-980d-21c4d48f680e',
        '1997-05-13',
        'Swedia',
        false,
        186,
        14,
        true
    ),
    (
        'f3174adc-cf10-4e8c-9131-5ab7d3c3a38e',
        '1996-06-14',
        'Brasil',
        true,
        188,
        1,
        true
    ),
    (
        'f24db237-4fb9-466c-a19e-dfd32ae03718',
        '1995-07-15',
        'Argentina',
        false,
        184,
        13,
        true
    );

INSERT INTO
    ATLET_PELATIH (ID_Pelatih, ID_Atlet)
VALUES
    (
        '29e88a08-e0ce-4983-8d2f-273c8f6f0c99',
        'ed9c30c2-33fe-44ea-9bbe-dd79d1c495c1'
    ),
    (
        '04aa6c0e-1c68-42c1-a5c0-28db4faf03e6',
        'd0e4990c-c628-45b8-b0f2-064e8d26e048'
    ),
    (
        '20a5180f-dbfb-49f6-8628-d3a3b9104be4',
        '67296d7a-2989-42cb-bae3-08b92c30263b'
    ),
    (
        'c8f18478-7bf8-42d3-b913-84aa136df0e3',
        '3484fd6a-19bc-4758-b503-614ccf2a8c35'
    ),
    (
        'fd502975-4ebe-43e2-bb2e-5c11b931a208',
        '5f1ee424-a18c-46f6-a706-4d13b741612e'
    ),
    (
        '29e88a08-e0ce-4983-8d2f-273c8f6f0c99',
        '6e256d6a-df83-4aa4-832f-17dc0558610a'
    ),
    (
        '04aa6c0e-1c68-42c1-a5c0-28db4faf03e6',
        'af9c7852-89ba-4059-93b0-7712e8139b76'
    ),
    (
        '20a5180f-dbfb-49f6-8628-d3a3b9104be4',
        '526a7450-211e-41ce-bcc7-59bcafe8ab03'
    ),
    (
        'c8f18478-7bf8-42d3-b913-84aa136df0e3',
        '06527cb8-e5cb-4839-b536-b6f73a9650f9'
    ),
    (
        'fd502975-4ebe-43e2-bb2e-5c11b931a208',
        '7074aef6-8cf0-4da3-9852-0b16caf15afd'
    ),
    (
        '29e88a08-e0ce-4983-8d2f-273c8f6f0c99',
        'af9c7852-89ba-4059-93b0-7712e8139b76'
    ),
    (
        '04aa6c0e-1c68-42c1-a5c0-28db4faf03e6',
        '6e256d6a-df83-4aa4-832f-17dc0558610a'
    ),
    (
        '20a5180f-dbfb-49f6-8628-d3a3b9104be4',
        '7074aef6-8cf0-4da3-9852-0b16caf15afd'
    ),
    (
        'c8f18478-7bf8-42d3-b913-84aa136df0e3',
        'd0e4990c-c628-45b8-b0f2-064e8d26e048'
    ),
    (
        'fd502975-4ebe-43e2-bb2e-5c11b931a208',
        '526a7450-211e-41ce-bcc7-59bcafe8ab03'
    ),
    (
        '29e88a08-e0ce-4983-8d2f-273c8f6f0c99',
        '71b31d77-4c9e-4b71-bbc4-bdf65019b659'
    ),
    (
        '04aa6c0e-1c68-42c1-a5c0-28db4faf03e6',
        'f0cf3333-c33c-41d3-aaf6-6292054f66f8'
    ),
    (
        '20a5180f-dbfb-49f6-8628-d3a3b9104be4',
        'bf17ba0d-c786-470d-980d-21c4d48f680e'
    ),
    (
        'c8f18478-7bf8-42d3-b913-84aa136df0e3',
        'f3174adc-cf10-4e8c-9131-5ab7d3c3a38e'
    ),
    (
        'fd502975-4ebe-43e2-bb2e-5c11b931a208',
        'f24db237-4fb9-466c-a19e-dfd32ae03718'
    );

INSERT INTO
    SPONSOR (ID, Nama_Brand, Website, CP_Name, CP_Email)
VALUES
    (
        'f0b2a20a-77f1-4e08-ba49-749e80b158f5',
        'Nike',
        'www.nike.com',
        'John Doe',
        'johndoe@nike.com'
    ),
    (
        'ad4f01dd-7dd4-4336-aebb-d77d870b6f2b',
        'Adidas',
        'www.adidas.com',
        'Jane Smith',
        'janesmith@adidas.com'
    ),
    (
        'c5395ec5-9391-4325-9548-1685e9022c3c',
        'Puma',
        'www.puma.com',
        'Bob Johnson',
        'bobjohnson@puma.com'
    ),
    (
        'fbaa7ca7-2b2f-48d9-9c1c-67f31bfbd79a',
        'Under Armour',
        'www.underarmour.com',
        'Alice Lee',
        'alicelee@underarmour.com'
    ),
    (
        'd5db5b5d-b3f2-4495-a6d1-9c31d6e2ca6c',
        'Reebok',
        'www.reebok.com',
        'David Wang',
        'davidwang@reebok.com'
    );

INSERT INTO
    ATLET_SPONSOR (ID_Atlet, ID_Sponsor, Tgl_Mulai, Tgl_Selesai)
VALUES
    (
        'ed9c30c2-33fe-44ea-9bbe-dd79d1c495c1',
        'f0b2a20a-77f1-4e08-ba49-749e80b158f5',
        '2022-01-02',
        '2022-10-11'
    ),
    (
        'd0e4990c-c628-45b8-b0f2-064e8d26e048',
        'ad4f01dd-7dd4-4336-aebb-d77d870b6f2b',
        '2022-04-03',
        '2022-02-01'
    ),
    (
        '67296d7a-2989-42cb-bae3-08b92c30263b',
        'c5395ec5-9391-4325-9548-1685e9022c3c',
        '2022-06-04',
        '2022-11-12'
    ),
    (
        '3484fd6a-19bc-4758-b503-614ccf2a8c35',
        'fbaa7ca7-2b2f-48d9-9c1c-67f31bfbd79a',
        '2022-12-05',
        '2022-08-16'
    ),
    (
        '5f1ee424-a18c-46f6-a706-4d13b741612e',
        'd5db5b5d-b3f2-4495-a6d1-9c31d6e2ca6c',
        '2022-06-06',
        '2022-05-22'
    ),
    (
        '6e256d6a-df83-4aa4-832f-17dc0558610a',
        'f0b2a20a-77f1-4e08-ba49-749e80b158f5',
        '2022-05-05',
        '2022-12-31'
    ),
    (
        'af9c7852-89ba-4059-93b0-7712e8139b76',
        'ad4f01dd-7dd4-4336-aebb-d77d870b6f2b',
        '2022-04-22',
        '2022-12-31'
    ),
    (
        '526a7450-211e-41ce-bcc7-59bcafe8ab03',
        'c5395ec5-9391-4325-9548-1685e9022c3c',
        '2022-01-12',
        '2022-12-31'
    ),
    (
        '06527cb8-e5cb-4839-b536-b6f73a9650f9',
        'fbaa7ca7-2b2f-48d9-9c1c-67f31bfbd79a',
        '2022-07-29',
        '2022-12-31'
    ),
    (
        '7074aef6-8cf0-4da3-9852-0b16caf15afd',
        'd5db5b5d-b3f2-4495-a6d1-9c31d6e2ca6c',
        '2022-01-18',
        '2022-12-31'
    ),
    (
        '71b31d77-4c9e-4b71-bbc4-bdf65019b659',
        'f0b2a20a-77f1-4e08-ba49-749e80b158f5',
        '2023-05-01',
        NULL
    ),
    (
        'f0cf3333-c33c-41d3-aaf6-6292054f66f8',
        'ad4f01dd-7dd4-4336-aebb-d77d870b6f2b',
        '2023-05-01',
        NULL
    ),
    (
        'bf17ba0d-c786-470d-980d-21c4d48f680e',
        'c5395ec5-9391-4325-9548-1685e9022c3c',
        '2023-05-01',
        NULL
    ),
    (
        'f3174adc-cf10-4e8c-9131-5ab7d3c3a38e',
        'fbaa7ca7-2b2f-48d9-9c1c-67f31bfbd79a',
        '2023-05-01',
        NULL
    ),
    (
        'f24db237-4fb9-466c-a19e-dfd32ae03718',
        'd5db5b5d-b3f2-4495-a6d1-9c31d6e2ca6c',
        '2023-05-01',
        NULL
    );

INSERT INTO
    ATLET_KUALIFIKASI (ID_Atlet, World_Rank, World_Tour_Rank)
VALUES
    ('ed9c30c2-33fe-44ea-9bbe-dd79d1c495c1', 1, 1),
    ('d0e4990c-c628-45b8-b0f2-064e8d26e048', 2, 2),
    ('67296d7a-2989-42cb-bae3-08b92c30263b', 3, 3),
    ('3484fd6a-19bc-4758-b503-614ccf2a8c35', 4, 4),
    ('5f1ee424-a18c-46f6-a706-4d13b741612e', 5, 5),
    ('6e256d6a-df83-4aa4-832f-17dc0558610a', 6, 6),
    ('af9c7852-89ba-4059-93b0-7712e8139b76', 7, 7),
    ('526a7450-211e-41ce-bcc7-59bcafe8ab03', 8, 8);

INSERT INTO
    ATLET_NON_KUALIFIKASI (ID_Atlet)
VALUES
    ('06527cb8-e5cb-4839-b536-b6f73a9650f9'),
    ('7074aef6-8cf0-4da3-9852-0b16caf15afd'),
    ('71b31d77-4c9e-4b71-bbc4-bdf65019b659'),
    ('f0cf3333-c33c-41d3-aaf6-6292054f66f8'),
    ('bf17ba0d-c786-470d-980d-21c4d48f680e'),
    ('f3174adc-cf10-4e8c-9131-5ab7d3c3a38e'),
    ('f24db237-4fb9-466c-a19e-dfd32ae03718');

INSERT INTO
    UJIAN_KUALIFIKASI (Tahun, Batch, Tempat, Tanggal)
VALUES
    (
        2023,
        1,
        'Gedung Serba Guna Jakarta',
        '2023-06-01'
    ),
    (
        2023,
        1,
        'Gedung Serba Guna Depok Utara',
        '2023-06-02'
    ),
    (
        2023,
        2,
        'Aula Universitas Indonesia',
        '2023-06-15'
    );

INSERT INTO
    ATLET_NONKUALIFIKASI_UJIAN_KUALIFIKASI (
        ID_Atlet,
        Tahun,
        Batch,
        Tempat,
        Tanggal,
        Hasil_Lulus
    )
VALUES
    (
        '06527cb8-e5cb-4839-b536-b6f73a9650f9',
        2023,
        1,
        'Gedung Serba Guna Jakarta',
        '2023-06-01',
        true
    ),
    (
        '7074aef6-8cf0-4da3-9852-0b16caf15afd',
        2023,
        1,
        'Gedung Serba Guna Jakarta',
        '2023-06-01',
        false
    ),
    (
        '71b31d77-4c9e-4b71-bbc4-bdf65019b659',
        2023,
        1,
        'Gedung Serba Guna Jakarta',
        '2023-06-01',
        true
    ),
    (
        'f0cf3333-c33c-41d3-aaf6-6292054f66f8',
        2023,
        1,
        'Gedung Serba Guna Depok Utara',
        '2023-06-02',
        false
    ),
    (
        'bf17ba0d-c786-470d-980d-21c4d48f680e',
        2023,
        1,
        'Gedung Serba Guna Depok Utara',
        '2023-06-02',
        true
    ),
    (
        'f3174adc-cf10-4e8c-9131-5ab7d3c3a38e',
        2023,
        2,
        'Aula Universitas Indonesia',
        '2023-06-15',
        false
    ),
    (
        'f24db237-4fb9-466c-a19e-dfd32ae03718',
        2023,
        2,
        'Aula Universitas Indonesia',
        '2023-06-15',
        true
    ),
    (
        '06527cb8-e5cb-4839-b536-b6f73a9650f9',
        2023,
        2,
        'Aula Universitas Indonesia',
        '2023-06-15',
        false
    ),
    (
        '7074aef6-8cf0-4da3-9852-0b16caf15afd',
        2023,
        2,
        'Aula Universitas Indonesia',
        '2023-06-15',
        true
    ),
    (
        '71b31d77-4c9e-4b71-bbc4-bdf65019b659',
        2023,
        2,
        'Aula Universitas Indonesia',
        '2023-06-15',
        false
    );

INSERT INTO
    ATLET_GANDA (
        ID_Atlet_Ganda,
        ID_Atlet_Kualifikasi,
        ID_Atlet_Kualifikasi_2
    )
VALUES
    -- Mixed
    (
        '3a52d452-b9e9-4bc4-96a1-eeeffbdc3124',
        'ed9c30c2-33fe-44ea-9bbe-dd79d1c495c1',
        '5f1ee424-a18c-46f6-a706-4d13b741612e'
    ),
    (
        '33a92994-2bc1-46b8-8656-27d6c5af6e27',
        'd0e4990c-c628-45b8-b0f2-064e8d26e048',
        '526a7450-211e-41ce-bcc7-59bcafe8ab03'
    ),
    (
        'e096e0d2-b8b8-4be1-bc1d-bd184e67c711',
        '67296d7a-2989-42cb-bae3-08b92c30263b',
        '6e256d6a-df83-4aa4-832f-17dc0558610a'
    ),
    (
        '872b3e5d-7f1a-438e-94ed-24fb82927c2b',
        '3484fd6a-19bc-4758-b503-614ccf2a8c35',
        'af9c7852-89ba-4059-93b0-7712e8139b76'
    ),
    -- Man Double
    (
        '0be2b2cf-16b9-4eab-8b94-7b35a13a822c',
        'd0e4990c-c628-45b8-b0f2-064e8d26e048',
        '3484fd6a-19bc-4758-b503-614ccf2a8c35'
    ),
    (
        'a37a2a2f-f9c2-44d3-8cf0-d3f7b30c4e4c',
        '6e256d6a-df83-4aa4-832f-17dc0558610a',
        '526a7450-211e-41ce-bcc7-59bcafe8ab03'
    ),
    -- Women Double
    (
        'f0e8e22d-5a5c-40fc-a0c6-8535f53c2f63',
        'ed9c30c2-33fe-44ea-9bbe-dd79d1c495c1',
        '5f1ee424-a18c-46f6-a706-4d13b741612e'
    ),
    (
        '3bc3aadd-97a1-4df1-aa18-c7fb4f4ce19e',
        '67296d7a-2989-42cb-bae3-08b92c30263b',
        'af9c7852-89ba-4059-93b0-7712e8139b76'
    );

INSERT INTO
    STADIUM (Nama, Alamat, Kapasitas, Negara)
VALUES
    (
        'Gelora Bung Karno',
        'Tanah Abang, Jakarta Pusat',
        80000,
        'Indonesia'
    ),
    (
        'Wembley Stadium',
        'Wembley, London HA9 0WS',
        90000,
        'Inggris'
    ),
    (
        'Allianz Arena',
        'Werner-Heisenberg-Allee, München, Jerman',
        75000,
        'Jerman'
    ),
    (
        'Emirates Stadium',
        'Hornsey Rd, London, Inggris',
        60000,
        'Inggris'
    ),
    (
        'Anfield',
        'Anfield Rd, Liverpool, Inggris',
        54000,
        'Inggris'
    );

INSERT INTO
    EVENT (
        Nama_Event,
        Tahun,
        Nama_Stadium,
        Negara,
        Tgl_Mulai,
        Tgl_Selesai,
        Kategori_Superseries,
        Total_Hadiah
    )
VALUES
    (
        'Indonesia Open',
        2023,
        'Gelora Bung Karno',
        'Indonesia',
        '2022-07-04',
        '2022-07-10',
        'S300',
        1000000
    ),
    (
        'England Open',
        2023,
        'Wembley Stadium',
        'Inggris',
        '2022-05-14',
        '2022-05-14',
        'S500',
        100000
    ),
    (
        'German Open',
        2023,
        'Allianz Arena',
        'Jerman',
        '2022-05-21',
        '2022-05-21',
        'S1000',
        500000
    );

INSERT INTO
    PARTAI_KOMPETISI (Jenis_Partai, Nama_Event, Tahun_Event)
VALUES
    ('MS', 'Indonesia Open', 2023),
    ('WS', 'Indonesia Open', 2023),
    ('MD', 'Indonesia Open', 2023),
    ('WD', 'Indonesia Open', 2023),
    ('XD', 'Indonesia Open', 2023),
    ('MS', 'German Open', 2023),
    ('WS', 'German Open', 2023),
    ('MD', 'German Open', 2023),
    ('WD', 'German Open', 2023),
    ('XD', 'German Open', 2023),
    ('MS', 'England Open', 2023),
    ('WS', 'England Open', 2023),
    ('MD', 'England Open', 2023),
    ('WD', 'England Open', 2023),
    ('XD', 'England Open', 2023);

INSERT INTO
    PESERTA_KOMPETISI (
        Nomor_Peserta,
        ID_Atlet_Ganda,
        ID_Atlet_Kualifikasi,
        World_Rank,
        World_Tour_Rank
    )
VALUES
    -- Peserta Kompetisi Non Ganda
    (
        1,
        NULL,
        'ed9c30c2-33fe-44ea-9bbe-dd79d1c495c1',
        1,
        1
    ),
    (
        2,
        NULL,
        'd0e4990c-c628-45b8-b0f2-064e8d26e048',
        2,
        2
    ),
    (
        3,
        NULL,
        '67296d7a-2989-42cb-bae3-08b92c30263b',
        3,
        3
    ),
    (
        4,
        NULL,
        '3484fd6a-19bc-4758-b503-614ccf2a8c35',
        4,
        4
    ),
    (
        5,
        NULL,
        '5f1ee424-a18c-46f6-a706-4d13b741612e',
        5,
        5
    ),
    (
        6,
        NULL,
        '6e256d6a-df83-4aa4-832f-17dc0558610a',
        6,
        6
    ),
    (
        7,
        NULL,
        'af9c7852-89ba-4059-93b0-7712e8139b76',
        7,
        7
    ),
    (
        8,
        NULL,
        '526a7450-211e-41ce-bcc7-59bcafe8ab03',
        8,
        8
    ),
    -- Peserta Kompetisi Ganda
    -- Mixed
    (
        9,
        '3a52d452-b9e9-4bc4-96a1-eeeffbdc3124',
        NULL,
        1,
        1
    ),
    (
        10,
        '33a92994-2bc1-46b8-8656-27d6c5af6e27',
        NULL,
        2,
        2
    ),
    (
        11,
        'e096e0d2-b8b8-4be1-bc1d-bd184e67c711',
        NULL,
        3,
        3
    ),
    (
        12,
        '872b3e5d-7f1a-438e-94ed-24fb82927c2b',
        NULL,
        4,
        4
    ),
    -- Man Double
    (
        13,
        '0be2b2cf-16b9-4eab-8b94-7b35a13a822c',
        NULL,
        5,
        5
    ),
    (
        14,
        'a37a2a2f-f9c2-44d3-8cf0-d3f7b30c4e4c',
        NULL,
        6,
        6
    ),
    -- Women Double
    (
        15,
        'f0e8e22d-5a5c-40fc-a0c6-8535f53c2f63',
        NULL,
        7,
        7
    ),
    (
        16,
        '3bc3aadd-97a1-4df1-aa18-c7fb4f4ce19e',
        NULL,
        8,
        8
    );

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

INSERT INTO
    PESERTA_MENDAFTAR_EVENT (Nomor_Peserta, Nama_Event, Tahun)
VALUES
    (1, 'Indonesia Open', 2023),
    (2, 'Indonesia Open', 2023),
    (8, 'Indonesia Open', 2023),
    (7, 'Indonesia Open', 2023),
    (11, 'Indonesia Open', 2023),
    (12, 'Indonesia Open', 2023),
    (3, 'German Open', 2023),
    (4, 'German Open', 2023),
    (5, 'German Open', 2023),
    (6, 'German Open', 2023),
    (13, 'German Open', 2023),
    (14, 'German Open', 2023),
    (9, 'England Open', 2023),
    (10, 'England Open', 2023);

INSERT INTO
    MATCH (
        Jenis_Babak,
        Tanggal,
        Tahun_Event,
        Waktu_Mulai,
        Total_Durasi,
        Nama_Event,
        ID_Umpire
    )
VALUES
    (
        'R32',
        '2023-07-12',
        2023,
        '10:00:00',
        120,
        'Indonesia Open',
        '4db94ea8-c5e1-40aa-97a5-3eb6d44f2811'
    ),
    (
        'Perempat Final',
        '2023-07-15',
        2023,
        '15:00:00',
        150,
        'Indonesia Open',
        'c4089711-83bd-496d-a2ea-8de1b77669be'
    ),
    (
        'Semifinal',
        '2023-07-16',
        2023,
        '18:00:00',
        180,
        'Indonesia Open',
        '96c72405-64c4-4346-9bf2-9ea6143b6b2b'
    ),
    (
        'Semifinal',
        '2023-08-12',
        2023,
        '18:00:00',
        180,
        'German Open',
        '96c72405-64c4-4346-9bf2-9ea6143b6b2b'
    ),
    (
        'Final',
        '2023-08-13',
        2023,
        '18:00:00',
        240,
        'German Open',
        '0c9e02f1-766a-4ef8-8cc1-ea1684a0f41e'
    ),
    (
        'Perempat Final',
        '2023-07-15',
        2023,
        '14:00:00',
        120,
        'England Open',
        '96c72405-64c4-4346-9bf2-9ea6143b6b2b'
    );

INSERT INTO
    PESERTA_MENGIKUTI_MATCH (
        Jenis_Babak,
        Tanggal,
        Waktu_Mulai,
        Nomor_Peserta,
        Status_Menang
    )
VALUES
    ('R32', '2023-07-12', '10:00:00', 1, false),
    ('R32', '2023-07-12', '10:00:00', 2, false),
    ('R32', '2023-07-12', '10:00:00', 3, false),
    ('R32', '2023-07-12', '10:00:00', 4, false),
    ('R32', '2023-07-12', '10:00:00', 5, false),
    ('R32', '2023-07-12', '10:00:00', 6, false),
    ('R32', '2023-07-12', '10:00:00', 7, false),
    ('R32', '2023-07-12', '10:00:00', 8, false),
    ('R32', '2023-07-12', '10:00:00', 9, false),
    ('R32', '2023-07-12', '10:00:00', 10, false),
    ('R32', '2023-07-12', '10:00:00', 11, false),
    ('R32', '2023-07-12', '10:00:00', 12, false),
    ('R32', '2023-07-12', '10:00:00', 13, false),
    ('R32', '2023-07-12', '10:00:00', 14, false),
    ('R32', '2023-07-12', '10:00:00', 15, false),
    ('R32', '2023-07-12', '10:00:00', 16, false),
    (
        'Perempat Final',
        '2023-07-15',
        '15:00:00',
        1,
        false
    ),
    (
        'Perempat Final',
        '2023-07-15',
        '15:00:00',
        2,
        false
    ),
    (
        'Perempat Final',
        '2023-07-15',
        '15:00:00',
        3,
        false
    ),
    (
        'Perempat Final',
        '2023-07-15',
        '15:00:00',
        4,
        false
    );

INSERT INTO
    GAME (
        No_Game,
        Durasi,
        Jenis_Babak,
        Tanggal,
        Waktu_Mulai
    )
VALUES
    (1, 120, 'R32', '2023-07-12', '10:00:00'),
    (
        2,
        150,
        'Perempat Final',
        '2023-07-15',
        '15:00:00'
    ),
    (3, 180, 'Semifinal', '2023-07-16', '18:00:00'),
    (4, 180, 'Semifinal', '2023-08-12', '18:00:00'),
    (5, 240, 'Final', '2023-08-13', '18:00:00'),
    (
        6,
        120,
        'Perempat Final',
        '2023-07-15',
        '14:00:00'
    ),
    (7, 120, 'R32', '2023-07-12', '10:00:00'),
    (
        8,
        150,
        'Perempat Final',
        '2023-07-15',
        '15:00:00'
    ),
    (9, 180, 'Semifinal', '2023-07-16', '18:00:00'),
    (10, 180, 'Semifinal', '2023-08-12', '18:00:00');

INSERT INTO
    PESERTA_MENGIKUTI_GAME (Nomor_Peserta, No_Game, Skor)
VALUES
    (1, 1, 100),
    (2, 1, 6),
    (3, 1, 84),
    (4, 1, 82),
    (5, 1, 76),
    (6, 1, 9),
    (7, 1, 47),
    (8, 1, 1),
    (9, 1, 82),
    (10, 1, 13),
    (11, 1, 30),
    (12, 1, 84),
    (13, 1, 78),
    (14, 1, 30),
    (1, 2, 14),
    (2, 2, 80),
    (3, 2, 59),
    (4, 2, 42),
    (5, 2, 1),
    (6, 2, 41),
    (7, 2, 24),
    (8, 2, 73),
    (9, 2, 29),
    (10, 2, 67),
    (11, 2, 54),
    (12, 2, 34),
    (13, 2, 14),
    (14, 2, 40),
    (1, 3, 91),
    (2, 3, 84),
    (3, 3, 73),
    (4, 3, 23),
    (5, 3, 71),
    (6, 3, 1),
    (7, 3, 38),
    (8, 3, 95),
    (9, 3, 68),
    (10, 3, 52),
    (11, 3, 25),
    (12, 3, 72),
    (13, 3, 74),
    (14, 3, 46),
    (1, 4, 9),
    (2, 4, 31),
    (3, 4, 69),
    (1, 5, 16),
    (1, 6, 10),
    (1, 7, 56),
    (1, 8, 70),
    (1, 10, 80);

INSERT INTO
    POINT_HISTORY (ID_Atlet, Minggu_Ke, Bulan, Tahun, Total_Point)
VALUES
    (
        'ed9c30c2-33fe-44ea-9bbe-dd79d1c495c1',
        5,
        'April',
        2023,
        1000000
    ),
    (
        'd0e4990c-c628-45b8-b0f2-064e8d26e048',
        5,
        'April',
        2023,
        120000
    ),
    (
        '67296d7a-2989-42cb-bae3-08b92c30263b',
        5,
        'April',
        2023,
        9049400
    ),
    (
        '3484fd6a-19bc-4758-b503-614ccf2a8c35',
        5,
        'April',
        2023,
        120000
    ),
    (
        '5f1ee424-a18c-46f6-a706-4d13b741612e',
        5,
        'April',
        2023,
        900000
    ),
    (
        '6e256d6a-df83-4aa4-832f-17dc0558610a',
        5,
        'April',
        2023,
        7000
    ),
    (
        'af9c7852-89ba-4059-93b0-7712e8139b76',
        5,
        'April',
        2023,
        80000
    ),
    (
        '526a7450-211e-41ce-bcc7-59bcafe8ab03',
        5,
        'April',
        2023,
        900000
    ),
    (
        '06527cb8-e5cb-4839-b536-b6f73a9650f9',
        5,
        'April',
        2023,
        1200000
    ),
    (
        '7074aef6-8cf0-4da3-9852-0b16caf15afd',
        5,
        'April',
        2023,
        189000
    ),
    (
        '71b31d77-4c9e-4b71-bbc4-bdf65019b659',
        5,
        'April',
        2023,
        240000
    ),
    (
        'f0cf3333-c33c-41d3-aaf6-6292054f66f8',
        5,
        'April',
        2023,
        80900
    ),
    (
        'bf17ba0d-c786-470d-980d-21c4d48f680e',
        5,
        'April',
        2023,
        1240000
    ),
    (
        'f3174adc-cf10-4e8c-9131-5ab7d3c3a38e',
        5,
        'April',
        2023,
        30000
    ),
    (
        'f24db237-4fb9-466c-a19e-dfd32ae03718',
        5,
        'April',
        2023,
        2000
    ),
    (
        'ed9c30c2-33fe-44ea-9bbe-dd79d1c495c1',
        1,
        'Mei',
        2023,
        7000
    ),
    (
        'd0e4990c-c628-45b8-b0f2-064e8d26e048',
        1,
        'Mei',
        2023,
        9000
    ),
    (
        '67296d7a-2989-42cb-bae3-08b92c30263b',
        1,
        'Mei',
        2023,
        4500
    ),
    (
        '3484fd6a-19bc-4758-b503-614ccf2a8c35',
        1,
        'Mei',
        2023,
        12000
    ),
    (
        '5f1ee424-a18c-46f6-a706-4d13b741612e',
        1,
        'Mei',
        2023,
        5000
    ),
    (
        '6e256d6a-df83-4aa4-832f-17dc0558610a',
        1,
        'Mei',
        2023,
        5500
    ),
    (
        'af9c7852-89ba-4059-93b0-7712e8139b76',
        1,
        'Mei',
        2023,
        12300
    ),
    (
        '526a7450-211e-41ce-bcc7-59bcafe8ab03',
        1,
        'Mei',
        2023,
        9000
    ),
    (
        '06527cb8-e5cb-4839-b536-b6f73a9650f9',
        1,
        'Mei',
        2023,
        3500
    ),
    (
        '7074aef6-8cf0-4da3-9852-0b16caf15afd',
        1,
        'Mei',
        2023,
        7600
    ),
    (
        '71b31d77-4c9e-4b71-bbc4-bdf65019b659',
        1,
        'Mei',
        2023,
        1200
    ),
    (
        'f0cf3333-c33c-41d3-aaf6-6292054f66f8',
        1,
        'Mei',
        2023,
        120
    ),
    (
        'bf17ba0d-c786-470d-980d-21c4d48f680e',
        1,
        'Mei',
        2023,
        4600
    ),
    (
        'f3174adc-cf10-4e8c-9131-5ab7d3c3a38e',
        1,
        'Mei',
        2023,
        7090
    ),
    (
        'f24db237-4fb9-466c-a19e-dfd32ae03718',
        1,
        'Mei',
        2023,
        800
    );