BEGIN TRANSACTION
GO

IF EXISTS (
	SELECT	*
	FROM	sys.objects
	WHERE	object_id = OBJECT_ID(N'dbo.FileManagerUpload')
	AND		TYPE IN (N'U')
)
BEGIN
	DROP TABLE dbo.FileManagerUpload;
END
GO

CREATE TABLE dbo.FileManagerUpload(
	fmUploadId		INT				NOT NULL IDENTITY(1,1)
	,fmUniqueId		VARCHAR(255)	NOT NULL
	,fmFileName		VARCHAR(255)	NULL
	,fmFileExt		VARCHAR(5)		NOT NULL
	,fmKeyId		INT				NOT NULL
	,PRIMARY KEY CLUSTERED (
		fmUploadId ASC
	) 
	WITH (
		PAD_INDEX = OFF
		,STATISTICS_NORECOMPUTE = OFF
		,IGNORE_DUP_KEY = OFF
		,ALLOW_ROW_LOCKS = ON
		,ALLOW_PAGE_LOCKS = ON
	) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE dbo.FileManagerUpload 
WITH CHECK 
ADD FOREIGN KEY(fmKeyId)
REFERENCES dbo.FileManagerKey (fmKeyId)
GO

COMMIT
