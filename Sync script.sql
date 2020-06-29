
DECLARE @SyncTable TABLE(Ord int IDENTITY(1,1), RequestID varchar(50), OBRSetID int, SyncStatus varchar(10), DatetimeStamp datetime)
DECLARE @i int = 1,
        @RequestID varchar(50),
		@OBRSetID int,
		@SyncStatus varchar(50)

INSERT INTO @SyncTable(RequestID, OBRSetID, SyncStatus, DatetimeStamp)
SELECT TOP 1000 RequestID, OBRSetID, SyncStatus, DatetimeStamp FROM OpenLDRData.dbo.SyncTable ORDER BY DatetimeStamp

WHILE (SELECT COUNT(1) FROM @SyncTable) >= @i 
BEGIN
   SELECT @RequestID = RequestID, @OBRSetID = OBRSetID, @SyncStatus = SyncStatus FROM @SyncTable WHERE Ord = @i

   IF @SyncStatus = 'INSERT'
   BEGIN
       -- Data insertion
	   EXEC OpenLDRData.dbo.insertAndUpdateIntoRequests @RequestID, @OBRSetID, 'INSERT'
	   DELETE FROM OpenLDRData.dbo.SyncTable WHERE RequestID = @RequestID AND OBRSetID = @OBRSetID
   END
   ELSE IF @SyncStatus = 'UPDATE'
   BEGIN
	   EXEC OpenLDRData.dbo.insertAndUpdateIntoRequests @RequestID, @OBRSetID, 'UPDATE'
       DELETE FROM OpenLDRData.dbo.SyncTable WHERE RequestID = @RequestID AND OBRSetID = @OBRSetID
   END 
   ELSE
   BEGIN
       -- Delete records
	   EXEC OpenLDRData.dbo.deleteIntoTableRequests @RequestID, @OBRSetID
	   DELETE FROM OpenLDRData.dbo.SyncTable WHERE RequestID = @RequestID AND OBRSetID = @OBRSetID
   END

   SET @i = @i + 1 
END



