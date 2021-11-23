--- FCC DB schema

-- Main Form 605 data that carries over to the license
CREATE TABLE t_hd (
	sys_id INTEGER PRIMARY KEY,
	uls_fileno TEXT,
	callsign TEXT,
	license_status TEXT,
	service_code TEXT,
	grant_date TEXT,
	expired_date TEXT,
	canceled_date TEXT,
	convicted TEXT,
	effective_date TEXT,
	last_action_date TEXT,
	name_change TEXT
);

-- amateur data
CREATE TABLE t_am (
	sys_id INTEGER PRIMARY KEY,
	uls_fileno TEXT,
	callsign TEXT,
	op_class TEXT,		-- T/G/E [blank for clubs]
	group_code TEXT,
	region_code INT,
	trustee_callsign TEXT,
	trustee_indicator TEXT,
	sys_call_change TEXT,
	vanity_call_change TEXT,
	previous_callsign TEXT,
	previous_op_class TEXT,
	trustee_name TEXT,
	district INT
);

-- names and addresses
CREATE TABLE t_en (
	sys_id INTEGER PRIMARY KEY,
	uls_fileno TEXT,
	callsign TEXT,
	entity_type TEXT,
	license_id TEXT,
	entity_name TEXT,
	first_name TEXT,
	mi TEXT,
	last_name TEXT,
	suffix TEXT,
	street TEXT,
	city TEXT,
	state TEXT,
	zip_code TEXT,
	po_box TEXT,
	attn TEXT,
	frn TEXT,
	type_code TEXT,		-- I=indiv, B=club
	district INT
);

-- application/license history
CREATE TABLE t_hs (
	id INTEGER PRIMARY KEY,
	sys_id INT NOT NULL,
	callsign TEXT,
	log_date TEXT,
	code TEXT
);

