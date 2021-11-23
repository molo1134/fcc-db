--- FCC App DB Schema

-- Main Form 605 data that carries over to the license
CREATE TABLE t_hd (
	sys_id INTEGER PRIMARY KEY,
	uls_fileno TEXT,
	callsign TEXT,
	license_status TEXT,
	service_code TEXT,	-- HA/HV
	grant_date TEXT,
	expired_date TEXT,
	canceled_date TEXT,
	convicted TEXT,
	effective_date TEXT,
	last_action_date TEXT,
	name_change TEXT
);

-- Main Form 605 data that does not carry over to the license
CREATE TABLE t_ad (
	sys_id INTEGER PRIMARY KEY,
	uls_fileno TEXT,
	purpose TEXT,
	status TEXT, 		-- application status: 2=Pending; G=granted; D=dismissed; R=returned; W=withdrawn
	source TEXT,
	receipt_date TEXT,
	orig_purpose TEXT,
	waver_req TEXT,
	has_attachment TEXT,
	entry_date TEXT
);

-- amateur data
CREATE TABLE t_am (
	sys_id INTEGER PRIMARY KEY,
	uls_fileno TEXT,
	callsign TEXT,
	op_class TEXT,		-- E=Extra, etc.
	group_code TEXT,	-- callsign group: A/B/C/D
	region_code INT,
	trustee_callsign TEXT,
	trustee_indicator TEXT,
	sys_call_change TEXT,
	vanity_call_change TEXT, -- "eligibility" A: Former holder; B: relative of deceased; C: Former holder (club); D: in Memoriam (club); E: by list; F: by list (club);
	previous_callsign TEXT,
	previous_op_class TEXT,
	trustee_name TEXT,
	district INT
);

-- requested vanity call sign
CREATE TABLE t_vc (
	sys_id INT,
	uls_fileno TEXT,
	pref_order INT,
	callsign TEXT,

	PRIMARY KEY (sys_id, pref_order)
) WITHOUT ROWID;

-- names and addresses
CREATE TABLE t_en (
	sys_id INTEGER PRIMARY KEY,
	uls_fileno TEXT,
	callsign TEXT,
	entity_type TEXT,	-- always L
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

-- application and license history
CREATE TABLE t_hs (
	id INTEGER PRIMARY KEY,
	sys_id INT NOT NULL,
	callsign TEXT,
	log_date TEXT,
	code TEXT
);

