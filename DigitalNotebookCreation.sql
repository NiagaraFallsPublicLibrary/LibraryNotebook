CREATE DATABASE DigitalNotebook;
GO
USE DigitalNotebook;
CREATE TABLE library (
	library_id		INT NOT NULL IDENTITY(1,1),
	library_name	NVARCHAR(255),
	library_website	NVARCHAR(255),		--Used to vailidate email account on login
	CONSTRAINT PK_library_id PRIMARY KEY NONCLUSTERED (library_id)
	);
GO
CREATE TABLE login (
	l_id 			INT NOT NULL IDENTITY(1,1),
	staff_name		NVARCHAR(255),
	title			NVARCHAR(255),
	email			VARCHAR(128),
	pass_hash		VARCHAR(255),
	external_type	VARCHAR(16),		--mainly to add google OAUTH but with a type to be on the safe side
	external_id		VARCHAR(64),
	library_id		INT	NOT NULL,		--must have a library to register 
	CONSTRAINT PK_l_id PRIMARY KEY NONCLUSTERED (l_id),
	CONSTRAINT FK_login_library_id FOREIGN KEY (library_id)
		REFERENCES [DigitalNotebook].[dbo].library (library_id) 
	);
GO
CREATE TABLE desk (
	desk_id				INT NOT NULL IDENTITY(1,1),
	branch				VARCHAR(255),
	library_id			INT,
	computer_name		VARCHAR(255),
	nickname			VARCHAR(255),
	CONSTRAINT PK_desk_id PRIMARY KEY NONCLUSTERED (desk_id),
	CONSTRAINT FK_desk_library_id FOREIGN KEY (library_id)
		REFERENCES [DigitalNotebook].[dbo].library (library_id) 
	);
GO
USE DigitalNotebook;
CREATE TABLE category (
	category_id			INT NOT NULL IDENTITY(1,1),
	category_name		VARCHAR(255),
	subcategory_of		INT DEFAULT 1,
	CONSTRAINT PK_category_id PRIMARY KEY NONCLUSTERED (category_id)  
	);
GO
INSERT INTO category (category_name, subcategory_of)
VALUES('root',1);
GO
-- Now that there is a root level category, the table can refer to itself. This way we can have trees of sub-categories.
ALTER TABLE category
ADD CONSTRAINT FK_subcategory_of FOREIGN KEY (subcategory_of) 
	REFERENCES category(category_id);
GO
--frequent interations will show up to the user as buttons instead of having to type them out
CREATE TABLE frequent_interation (
	fiid		INT NOT NULL IDENTITY(1,1),	--Frequent Interations IDentity
	interaction	NVARCHAR(MAX),
	category_id	INT,
	library_id	INT,
	l_id		INT,
	desk_id		INT,
	CONSTRAINT PK_frequent_intercation_id PRIMARY KEY NONCLUSTERED (fiid),
	CONSTRAINT FK_frequent_desk_id FOREIGN KEY (desk_id)
		REFERENCES [DigitalNotebook].[dbo].[desk] (desk_id),
	CONSTRAINT FK_frequent_l_id FOREIGN KEY (l_id)
		REFERENCES [DigitalNotebook].[dbo].[login] (l_id),
	CONSTRAINT FK_frequent_library_id FOREIGN KEY (library_id)
		REFERENCES [DigitalNotebook].[dbo].[library] (library_id),
	CONSTRAINT FK_frequent_category_id FOREIGN KEY (category_id)
		REFERENCES [DigitalNotebook].[dbo].category (category_id)  
	);
USE DigitalNotebook;
CREATE TABLE patron_interaction (
	interaction_id	INT NOT NULL IDENTITY(1,1),
	recieved		DATETIME DEFAULT GETDATE(),
	multiplier		INT DEFAULT 1,
	interaction		NVARCHAR(MAX),
	l_id			INT,
	desk_id			INT,
	category_id		INT,
	library_id		INT,
	CONSTRAINT PK_interaction_id PRIMARY KEY NONCLUSTERED (interaction_id),
	CONSTRAINT FK_interaction_desk_id FOREIGN KEY (desk_id)
		REFERENCES [DigitalNotebook].[dbo].[desk] (desk_id),
	CONSTRAINT FK_interaction_l_id FOREIGN KEY (l_id)
		REFERENCES [DigitalNotebook].[dbo].[login] (l_id),
	CONSTRAINT FK_interaction_library_id FOREIGN KEY (library_id)
		REFERENCES [DigitalNotebook].[dbo].[library] (library_id),
	CONSTRAINT FK_interaction_category_id FOREIGN KEY (category_id)
		REFERENCES [DigitalNotebook].[dbo].category (category_id)  
	);



