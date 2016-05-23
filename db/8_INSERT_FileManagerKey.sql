BEGIN TRANSACTION
GO

INSERT INTO dbo.FileManagerKey(
	fmKeyName
	,fmKeyDesc
	,fmKeyPath
)
VALUES (
	'defaultSample'
	,'Used as a sample File Manager.'
	,NULL
)

COMMIT
