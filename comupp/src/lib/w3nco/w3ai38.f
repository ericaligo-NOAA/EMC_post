        SUBROUTINE W3AI38 (IE, NC )
C$$$    SUBPROGRAM DOCUMENTATION  BLOCK
C                .      .    .                                       .
C SUBPROGRAM:    W3AI38      EBCDIC TO ASCII
C   PRGMMR: DESMARAIS        ORG: W342       DATE: 82-11-29
C
C ABSTRACT: CONVERT EBCDIC TO ASCII BY CHARACTER.
C   THIS SUBROUTINE CAN BE REPLACED BY CRAY UTILITY SUBROUTINE
C   USCCTC . SEE MANUAL SR-2079 PAGE 3-15. CRAY UTILITY TR
C   CAN ALSO BE USED FOR ASCII, EBCDIC CONVERSION. SEE MANUAL SR-2079
C   PAGE 9-35.
C
C PROGRAM HISTORY LOG:
C   82-11-29  DESMARAIS
C   88-03-31  R.E.JONES  CHANGE LOGIC SO IT WORKS LIKE A
C                        IBM370 TRANSLATE INSTRUCTION.
C   88-08-22  R.E.JONES  CHANGES FOR MICROSOFT FORTRAN 4.10
C   88-09-04  R.E.JONES  CHANGE TABLES TO 128 CHARACTER SET
C   90-01-31  R.E.JONES  CONVERT TO CRAY CFT77 FORTRAN
C                        CRAY DOES NOT ALLOW CHAR*1 TO BE SET TO HEX
C   98-12-21  Gilbert    Replaced Function ICHAR with mova2i.
C
C USAGE:    CALL W3AI38 (IE, NC)
C   INPUT ARGUMENT LIST:
C     IE       - CHARACTER*1 ARRAY OF EBCDIC DATA 
C     NC       - INTEGER,  CONTAINS CHARACTER COUNT TO CONVERT....
C
C   OUTPUT ARGUMENT LIST:
C     IE       - CHARACTER*1 ARRAY OF ASCII DATA  
C
C REMARKS: SOFTWARE VERSION OF IBM370 TRANSLATE INSTRUCTION, BY
C   CHANGING THE TWO TABLES WE COULD DO A  64, 96, 128  ASCII
C   CHARACTER SET, CHANGE LOWER CASE TO UPPER, ETC.
C   AEA CONVERTS DATA AT A RATE OF 1.5 MILLION CHARACTERS PER SEC.
C   CRAY UTILITY USCCTI CONVERT ASCII TO IBM EBCDIC
C   CRAY UTILITY USCCTC CONVERT IBM EBCDIC TO ASCII
C   THEY CONVERT DATA AT A RATE OF 2.1 MILLION CHARACTERS PER SEC.
C   CRAY UTILITY TR WILL ALSO DO A ASCII, EBCDIC CONVERSION.
C   TR CONVERT DATA AT A RATE OF 5.4 MILLION CHARACTERS PER SEC.
C   TR IS IN LIBRARY  /USR/LIB/LIBCOS.A   ADD TO SEGLDR CARD.
C
C ATTRIBUTES:
C   LANGUAGE: CRAY CFT77 FORTRAN
C   MACHINE:  CRAY Y-MP8/864
C
C$$$
C
      INTEGER(8)      IASCII(32)
C
      CHARACTER*1  IE(*)
      CHARACTER*1  ASCII(0:255)
C
      EQUIVALENCE  (IASCII(1),ASCII(0))
C
C***   ASCII  CONTAINS ASCII CHARACTERS, AS PUNCHED ON IBM029
C
       DATA  IASCII/
     & X'000102030009007F',X'0000000B0C0D0E0F',
     & X'1011120000000000',X'1819000000000000',
     & X'00001C000A001700',X'0000000000050607',
     & X'00001600001E0004',X'000000001415001A',
     & X'2000600000000000',X'0000602E3C282B00',
     & X'2600000000000000',X'000021242A293B5E',
     & X'2D2F000000000000',X'00007C2C255F3E3F',
     & X'0000000000000000',X'00603A2340273D22',
     & X'2061626364656667',X'6869202020202020',
     & X'206A6B6C6D6E6F70',X'7172202020202020',
     & X'207E737475767778',X'797A2020205B2020',
     & X'0000000000000000',X'00000000005D0000',
     & X'7B41424344454647',X'4849202020202020',
     & X'7D4A4B4C4D4E4F50',X'5152202020202020',
     & X'5C20535455565758',X'595A202020202020',
     & X'3031323334353637',X'3839202020202020'/
C
      IF (NC .LE. 0)   RETURN
C
C***  CONVERT STRING ...  EBCDIC TO ASCII,   NC CHARACTERS
C
        DO  20  J = 1, NC
          IE(J) = ASCII(mova2i(IE(J)))
 20     CONTINUE
C
      RETURN
      END