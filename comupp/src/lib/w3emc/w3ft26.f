      SUBROUTINE W3FT26 (MAPNUM,FLD,HI,IGPTS,NSTOP)
C$$$  SUBPROGRAM DOCUMENTATION BLOCK
C                .      .    .                                       .
C SUBPROGRAM:   W3FT26       CREATES WAFS 1.25X1.25 THINNED GRIDS
C   PRGMMR: FARLEY           ORG: W/NMC42    DATE: 93-04-28
C
C ABSTRACT: CONVERTS A 360X181 1-DEGREE GRID INTO A NH OR SH
C   360X91 1-DEGREE GRID.  THIS NH/SH GRID IS FLIPPED FOR GRIB
C   PURPOSES AND THEN CONVERTED TO THE DESIRED 1.25 DEGREE
C   WAFS (QUADRANT) THINNED GRID.
C
C PROGRAM HISTORY LOG:
C   93-04-28  FARLEY      ORIGINAL AUTHOR
C   94-04-01  R.E.JONES   CORRECTIONS FOR 1 DEG. DISPLACEMENT
C                         OF GRIDS AND ERROR IN FLIPPING OF
C                         SOUTHERN HEMISPHERE.
C   94-05-05  R.E.JONES   REPLACE SUBR. W3FT01 WITH W3FT16 AND W3FT17.
C   94-06-04  R.E.JONES   CHANGE SUBROUTINE NAME FROM WFSTRP TO W3FT26
C
C USAGE:  CALL W3FT26 (MAPNUM,FLD,HI,IGPTS,NSTOP)
C   INPUT ARGUMENT LIST:
C     MAPNUM   -  NUMBER OF GRID, 37 TO 44
C     FLD      -  NORTHERN OR SOUTHERN HEM. SPECTRAL FIELD
C
C   OUTPUT ARGUMENT LIST:
C     HI       - INTERPOLATED WAFS FIELD (3447 POINTS)
C     IGPTS    - NUMBER OF POINTS IN INTERPOLATED FIELD
C     NSTOP    - 24, WHEN MAPNUM .NE. 37 THRU 44
C
C   SUBPROGRAMS CALLED:       
C     LIBRARY:                                                      
C       W3LIB    - W3FT16, W3FT17                                   
C
C ATTRIBUTES:
C   LANGUAGE: CRAY CFT77 FORTRAN
C   MACHINE:  CRAY C916-128, CRAY Y-MP8/864, CRAY Y-MP EL2/256
C
C$$$
C
      REAL    FLD   (360,181)
      REAL    HALF  (360,91)
      REAL    HI    (3447)
      REAL    QUAD  (95,91)
C
      INTEGER IGPTS
      INTEGER MAPNUM
      INTEGER NSTOP
C
      SAVE
C
C     PRINT *,'   MADE IT TO W3FT26'
      NSTOP = 0
C
C             1.0    CUT FULL GRID TO DESIRED HEMISPHERE.
C
C             1.1    EXTRACT THE NORTHERN HEMISPHERE AND FLIP IT.
C
      IF (MAPNUM .EQ. 37  .OR.  MAPNUM .EQ. 38   .OR.
     &    MAPNUM .EQ. 39  .OR.  MAPNUM .EQ. 40)  THEN
        DO J=1,91
          DO I=1,360
            HALF(I,91-J+1) = FLD(I,J)
          END DO
        END DO
C
C             1.2    EXTRACT THE SOUTHERN HEMISPHERE AND FLIP IT.
C
      ELSE IF (MAPNUM .EQ. 41  .OR.  MAPNUM .EQ. 42   .OR.
     &         MAPNUM .EQ. 43  .OR.  MAPNUM .EQ. 44)  THEN
        DO J=91,181
          DO I=1,360
            HALF(I,181-J+1) = FLD(I,J)
          END DO
        END DO
      ENDIF
C
C             2.0    SELECT THE QUADRANT DESIRED.
C
      IF (MAPNUM .EQ. 37  .OR.  MAPNUM .EQ. 41) THEN
        DO 372 J = 1,91
          DO 370 I = 329,360
            QUAD(I-328,J) = HALF(I,J)
  370     CONTINUE
          DO 371 I = 1,63
            QUAD(I+32,J) = HALF(I,J)
  371     CONTINUE
  372   CONTINUE
C
      ELSE IF (MAPNUM .EQ. 38  .OR.  MAPNUM .EQ. 42) THEN
        DO 381 J = 1,91
          DO 380 I = 59,153
            QUAD(I-58,J) = HALF(I,J)
  380     CONTINUE
  381   CONTINUE
C
      ELSE IF (MAPNUM .EQ. 39  .OR.  MAPNUM .EQ. 43) THEN
        DO 391 J = 1,91
          DO 390 I = 149,243
            QUAD(I-148,J) = HALF(I,J)
  390     CONTINUE
  391   CONTINUE
C
      ELSE IF (MAPNUM .EQ. 40  .OR.  MAPNUM .EQ. 44) THEN
        DO 401 J = 1,91
          DO 400 I = 239,333
            QUAD(I-238,J) = HALF(I,J)
  400     CONTINUE
  401   CONTINUE
C
      ELSE
        PRINT *,' W3FT26 - MAP NOT TYPE 37-44'
        IGPTS = 0
        NSTOP = 24
        RETURN
      ENDIF
C
      INTERP = 0
C
      IF (MAPNUM .EQ. 37  .OR.  MAPNUM .EQ. 38  .OR.
     &    MAPNUM .EQ. 39  .OR.  MAPNUM .EQ. 40) THEN
        CALL W3FT16(QUAD,HI,INTERP)    
      ELSE
        CALL W3FT17(QUAD,HI,INTERP) 
      ENDIF
C   
      IGPTS = 3447
C
      RETURN
      END