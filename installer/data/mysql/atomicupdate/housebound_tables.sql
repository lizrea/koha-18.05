CREATE TABLE IF NOT EXISTS `housebound_profile` (
  `borrowernumber` int(11) NOT NULL, -- Number of the borrower associated with this profile.
  `day` text NOT NULL,  -- The preferred day of the week for delivery.
  `frequency` text NOT NULL, -- The Authorised_Value definining the pattern for delivery.
  `fav_itemtypes` text default NULL, -- Free text describing preferred itemtypes.
  `fav_subjects` text default NULL, -- Free text describing preferred subjects.
  `fav_authors` text default NULL, -- Free text describing preferred authors.
  `referral` text default NULL, -- Free text indicating how the borrower was added to the service.
  `notes` text default NULL, -- Free text for additional notes.
  PRIMARY KEY  (`borrowernumber`),
  CONSTRAINT `housebound_profile_bnfk`
    FOREIGN KEY (`borrowernumber`)
    REFERENCES `borrowers` (`borrowernumber`)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

CREATE TABLE IF NOT EXISTS `housebound_visit` (
  `id` int(11) NOT NULL auto_increment, -- ID of the visit.
  `borrowernumber` int(11) NOT NULL, -- Number of the borrower, & the profile, linked to this visit.
  `appointment_date` date default NULL, -- Date of visit.
  `day_segment` varchar(10),  -- Rough time frame: 'morning', 'afternoon' 'evening'
  `chooser_brwnumber` int(11) default NULL, -- Number of the borrower to choose items  for delivery.
  `deliverer_brwnumber` int(11) default NULL, -- Number of the borrower to deliver items.
  PRIMARY KEY  (`id`),
  CONSTRAINT `houseboundvisit_bnfk`
    FOREIGN KEY (`borrowernumber`)
    REFERENCES `housebound_profile` (`borrowernumber`)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `houseboundvisit_bnfk_1`
    FOREIGN KEY (`chooser_brwnumber`)
    REFERENCES `borrowers` (`borrowernumber`)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT `houseboundvisit_bnfk_2`
    FOREIGN KEY (`deliverer_brwnumber`)
    REFERENCES `borrowers` (`borrowernumber`)
    ON UPDATE CASCADE ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

INSERT IGNORE INTO systempreferences
       (variable,value,options,explanation,type) VALUES
       ('HouseboundModule',0,'',
       'If ON, enable housebound module functionality.','YesNo');

INSERT IGNORE INTO authorised_values (category, authorised_value, lib) VALUES
       ('HSBND_FREQ','EW','Every week'),
       ('HSBND_ROLE','CHO','Chooser'),
       ('HSBND_ROLE','DEL','Deliverer');

INSERT IGNORE INTO borrower_attribute_types
       (code, description, repeatable, opac_display, staff_searchable,
       authorised_value_category, display_checkout) values
       ('HSBND', 'Housebound role', 1, 1, 1, 'HSBND_ROLE', 1);