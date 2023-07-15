UPDATE ATLET a
SET World_Rank = NULLIF(COALESCE((SELECT COUNT(*) FROM (
  SELECT ID_Atlet, SUM(Total_Point) as TotalPoints
  FROM POINT_HISTORY
  GROUP BY ID_Atlet
  ) ph
WHERE ph.TotalPoints >= (
  SELECT SUM(Total_Point) as TotalPoints
  FROM POINT_HISTORY
  WHERE ID_Atlet = a.ID
  GROUP BY ID_Atlet
)), (SELECT COUNT(*) FROM ATLET) + 1), 0);

UPDATE ATLET_KUALIFIKASI a
SET World_Rank = NULLIF(COALESCE((SELECT COUNT(*) FROM (
  SELECT ID_Atlet, SUM(Total_Point) as TotalPoints
  FROM POINT_HISTORY
  GROUP BY ID_Atlet
  ) ph
WHERE ph.TotalPoints >= (
  SELECT SUM(Total_Point) as TotalPoints
  FROM POINT_HISTORY
  WHERE ID_Atlet = a.ID_Atlet
  GROUP BY ID_Atlet
)), (SELECT COUNT(*) FROM ATLET_KUALIFIKASI) + 1), 0);


UPDATE ATLET_KUALIFIKASI a
SET world_tour_rank = (
  SELECT World_Rank from ATLET_KUALIFIKASI ak where ak.ID_Atlet = a.ID_Atlet
)
WHERE a.ID_Atlet in (
  select ID_Atlet from ATLET_KUALIFIKASI
);
