INSERT INTO
    SPESIALISASI (ID, Spesialisasi)
VALUES
    (
        '83a91d0c-58f3-4763-b6f9-2a9a8bb74e2e',
        'tunggal putra'
    ),
    (
        'b71e0908-63a7-4d84-9cb9-8a372f758c0e',
        'tunggal putri'
    ),
    (
        '4e4c4b4a-774b-4e9f-8ab3-3e534f90b0d2',
        'ganda putra'
    ),
    (
        'a4e205fc-33c4-4d38-a77d-0c5a8af0d5c5',
        'ganda putri'
    ),
    (
        '453ae9c9-c8e4-4a4d-99f5-56c5d2e5e5f5',
        'ganda campuran'
    );

    
    INSERT INTO PELATIH_SPESIALISASI (ID_Pelatih, ID_Spesialisasi)
SELECT '29e88a08-e0ce-4983-8d2f-273c8f6f0c99', ID FROM SPESIALISASI WHERE Spesialisasi = 'Teknik Lob';