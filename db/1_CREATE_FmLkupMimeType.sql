BEGIN TRANSACTION
GO

IF EXISTS (
	SELECT	*
	FROM	sys.objects
	WHERE	object_id = OBJECT_ID(N'dbo.FmLkupMimeType')
	AND		TYPE IN (N'U')
)
BEGIN
	DROP TABLE dbo.FmLkupMimeType;
END
GO

CREATE TABLE dbo.FmLkupMimeType(
	fmMimeTypeId	INT				NOT NULL IDENTITY(1,1)
	,fmMimeTypeName	VARCHAR(255)	NOT NULL
	,fmMimeType		VARCHAR(255)	NOT NULL
	,PRIMARY KEY CLUSTERED (
		fmMimeTypeId ASC
	)
	WITH (
		PAD_INDEX = OFF
		,STATISTICS_NORECOMPUTE = OFF
		,IGNORE_DUP_KEY = OFF
		,ALLOW_ROW_LOCKS = ON
		,ALLOW_PAGE_LOCKS = ON
	) ON [PRIMARY]
	,CONSTRAINT [IX_FLMT_Un_fMTN_fMT] UNIQUE NONCLUSTERED (
		fmMimeTypeName ASC
		,fmMimeType ASC
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

COMMIT
