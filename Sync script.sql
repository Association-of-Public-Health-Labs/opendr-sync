
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
	   INSERT INTO LDR.OpenLDRData.dbo.Requests
	   SELECT * FROM OpenLDRData.dbo.Requests WHERE RequestID = @RequestID AND OBRSetID = @OBRSetID
	   DELETE FROM OpenLDRData.dbo.SyncTable WHERE RequestID = @RequestID AND OBRSetID = @OBRSetID
   END
   ELSE IF @SyncStatus = 'UPDATE'
   BEGIN
       UPDATE LDR.OpenLDRData.dbo.Requests 
	   SET LIMSPanelCode = loc.LIMSPanelCode,
	       SpecimenDatetime = loc.SpecimenDatetime,
		   ReceivedDateTime = loc.ReceivedDateTime
	   FROM LDR.OpenLDRData.dbo.Requests AS central
	   JOIN OpenLDRData.dbo.Requests AS loc ON loc.RequestID = central.RequestID AND loc.OBRSetID = central.OBRSetID
	    
       DELETE FROM OpenLDRData.dbo.SyncTable WHERE RequestID = @RequestID AND OBRSetID = @OBRSetID
   END 
   ELSE
   BEGIN
       -- Delete records
	   DELETE FROM LDR.OpenLDRData.dbo.Requests WHERE RequestID = @RequestID AND OBRSetID = @OBRSetID 
	   DELETE FROM OpenLDRData.dbo.SyncTable WHERE RequestID = @RequestID AND OBRSetID = @OBRSetID
   END

   SET @i = @i + 1 
END



