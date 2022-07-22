--количество исполнителей в каждом жанре;
SELECT name, count(performer_id) FROM performers_genres pg
LEFT JOIN genres g ON pg.genre_id = g.id
GROUP BY g.name;

--количество треков, вошедших в альбомы 2019-2020 годов;
SELECT count (t.id) FROM tracks t
LEFT JOIN albums a ON a.id = t.album_id
where album_release_year BETWEEN  '01.01.2019' and '31.12.2020';

--средняя продолжительность треков по каждому альбому;
SELECT a.name, avg(length)  FROM albums a 
LEFT JOIN tracks t ON a.id = t.album_id 
group BY a.id;

--все исполнители, которые не выпустили альбомы в 2020 году;
SELECT DISTINCT nickname FROM performers p
WHERE p.id <> (SELECT p.id FROM performers p
	LEFT JOIN performers_albums pa ON pa.performer_id = p.id
	LEFT JOIN albums a ON a.id = pa.album_id WHERE album_release_year BETWEEN '01.01.2020' and '31.12.2020');

--названия сборников, в которых присутствует конкретный исполнитель (выберите сами);
SELECT  DISTINCT mt.name  FROM tracks t
LEFT JOIN albums a ON a.id = t.album_id
LEFT JOIN performers_albums pa ON pa.album_id = a.id
LEFT JOIN performers p ON p.id = pa.performer_id
FULL JOIN tracks_in_a_mix_tape tiamt ON tiamt.track_id  = t.id 
FULL JOIN mix_tapes mt ON mt.id  = tiamt.mix_tapes_id  
WHERE nickname = 'Louis Armstrong';

--название альбомов, в которых присутствуют исполнители более 1 жанра;
SELECT name FROM albums a
LEFT JOIN performers_albums pa ON pa.album_id = a.id
LEFT JOIN performers p ON p.id = pa.performer_id
LEFT JOIN performers_genres pg ON pg.performer_id = p.id
GROUP BY a.name
HAVING count(pg.genre_id) >1;

--наименование треков, которые не входят в сборники;
SELECT t.name FROM tracks t 
LEFT JOIN tracks_in_a_mix_tape tiamt ON tiamt.track_id = t.id
WHERE tiamt.mix_tapes_id ISNULL;

--исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько);
SELECT p.nickname  FROM tracks t
LEFT JOIN albums a ON a.id = t.album_id
LEFT JOIN performers_albums pa ON pa.album_id = a.id
LEFT JOIN performers p ON p.id = pa.performer_id
WHERE t.length = (SELECT min (t.length) FROM tracks t);

--название альбомов, содержащих наименьшее количество треков
SELECT DISTINCT a.name FROM albums a
LEFT JOIN tracks t ON a.id = t.album_id
WHERE t.album_id IN (
	SELECT album_id FROM tracks t GROUP BY album_id	HAVING count(t.id) = (
		SELECT count(t.id) FROM tracks t GROUP BY album_id ORDER BY count LIMIT 1)) ORDER BY a.name;

