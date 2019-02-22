CREATE DATABASE DigitalNotebook;
GO
USE DigitalNotebook;
CREATE TABLE desk (
	desk_id				INT NOT NULL IDENTITY(1,1),
	branch				VARCHAR(255),
	library_name		VARCHAR(255),
	computer_name		VARCHAR(255),
	nickname			VARCHAR(255),
	CONSTRAINT PK_desk_id PRIMARY KEY NONCLUSTERED (desk_id)
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

USE DigitalNotebook;
CREATE TABLE interaction (
	interaction_id	INT NOT NULL,
	recieved		DATETIME DEFAULT GETDATE(),
	multiplier		INT DEFAULT 1,
	interaction		NVARCHAR(MAX),
	staff_name		NVARCHAR(255),
	desk_id			INT NOT NULL,
	category_id		INT NOT NULL,
	CONSTRAINT PK_intercation_id PRIMARY KEY NONCLUSTERED (interaction_id),
	CONSTRAINT FK_desk_id FOREIGN KEY (desk_id)
		REFERENCES [DigitalNotebook].[dbo].[desk] (desk_id),
	CONSTRAINT FK_category_id FOREIGN KEY (category_id)
		REFERENCES [DigitalNotebook].[dbo].category (category_id)  
	);


