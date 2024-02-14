-- В базе данных есть две таблицы - одна с установками наших игр и вторая с событиями прохождения уровней.
-- Используя эти две таблицы необходимо рассчитать среднее количество уровней, пройденное в первые сутки игры, по всем
-- игрокам, в группировке по проектам. Результат вывести в порядке убывания среднего количества пройденных уровней.
-- Примечание: установкой здесь считается первое открытие приложения, т.е. install_time это по сути время первой сессии.


SELECT app_name
	, ROUND(AVG(levels), 2) AS average_levels
FROM (
	SELECT user_id
		, app_name
		, ROUND(SUM(level), 2) AS levels
		, date_trunc('day', event_time)::DATE AS date
	FROM (
		SELECT *
		FROM levels l
		LEFT JOIN installs i
		ON i.id = l.user_id
		WHERE event_time <= (install_time + INTERVAL '24 hours')
	) sq
	GROUP BY user_id, app_name, date_trunc('day', event_time)
) sq2
GROUP BY app_name
ORDER BY average_levels DESC
