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
        PRIMARY KEY (ID_Atlet, Tahun, Batch, Hasil_Lulus, Tempat, Tanggal),
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

CREATE TABLE
    PARTAI_KOMPETISI (
        Jenis_Partai CHAR(2),
        Nama_Event VARCHAR(50),
        Tahun_Event INT,
        PRIMARY KEY (Jenis_Partai, Nama_Event, Tahun_Event),
        FOREIGN KEY (Nama_Event, Tahun_Event) REFERENCES EVENT (Nama_Event, Tahun_Event)
    );

CREATE TABLE
    PARTAI_PESERTA_KOMPETISI (
        Jenis_Partai CHAR(2),
        Nama_Event VARCHAR(50),
        Tahun_Event INT,
        Nomor_Peserta INT,
        PRIMARY KEY (Jenis_Partai, Nama_Event, Tahun_Event,Nomor_Peserta),
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