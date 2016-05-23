BEGIN TRANSACTION
GO

INSERT INTO dbo.FmKeyMimeType(
	fmKeyId
	,fmMimeTypeId
)
VALUES
	(1, 175)
	,(1, 194)

COMMIT
