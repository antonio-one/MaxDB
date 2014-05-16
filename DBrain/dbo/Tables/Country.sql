CREATE TABLE [dbo].[Country] (
    [CountryId]   SMALLINT     NOT NULL,
    [ISO2]        CHAR (2)     NOT NULL,
    [ShortName]   VARCHAR (80) NOT NULL,
    [LongName]    VARCHAR (80) NOT NULL,
    [ISO3]        CHAR (3)     NOT NULL,
    [NumericCode] VARCHAR (6)  NOT NULL,
    [UNMember]    VARCHAR (12) NOT NULL,
    [CallingCode] VARCHAR (8)  NULL,
    [CCTLD]       VARCHAR (5)  NOT NULL,
    CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED ([CountryId] ASC)
);

