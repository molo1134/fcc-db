CREATE TEMP TABLE tmp_ivc AS
SELECT
	sys_id,
	callsign,
	license_status,
	grant_date,
	max(
		(coalesce(
			canceled_date,
			expired_date
		))
	) AS end_date,
	last_action_date
FROM
	t_hd
WHERE
	length(callsign) = 4
	AND
	callsign NOT IN (
		SELECT callsign FROM t_hd WHERE license_status = 'A'
	)
GROUP BY
	callsign
ORDER BY
	end_date DESC,
	callsign
;

