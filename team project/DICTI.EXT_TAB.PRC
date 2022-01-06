CREATE OR REPLACE PROCEDURE DICTI.ext_tab
IS
   CURSOR c_word
   IS
      SELECT DISTINCT LOWER (TRIM (word)) word
                 FROM ext_txttab;

   v_word   VARCHAR2 (1024);
BEGIN
   FOR i IN c_word
   LOOP
      BEGIN
         SELECT word
           INTO v_word
           FROM dictword
          WHERE LOWER (word) = LOWER (i.word);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_word := NULL;
      END;

      IF v_word IS NULL
      THEN
         IF SUBSTR (i.word, LENGTH (i.word)) IN (',', '.', '!', '"', '¿')
         THEN
            BEGIN
               INSERT INTO dictword
                           (word
                           )
                    VALUES (SUBSTR (i.word, 1, LENGTH (i.word) - 1)
                           );
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;
         ELSIF SUBSTR (i.word, 1, 1) IN (',', '.', '!', '"', '¿')
         THEN
            BEGIN
               INSERT INTO dictword
                           (word
                           )
                    VALUES (SUBSTR (i.word, 2)
                           );
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;
         ELSE
            BEGIN
               INSERT INTO dictword
                           (word
                           )
                    VALUES (i.word
                           );
            EXCEPTION
               WHEN OTHERS
               THEN
                  NULL;
            END;
         END IF;
      END IF;
   END LOOP;
END;
/
