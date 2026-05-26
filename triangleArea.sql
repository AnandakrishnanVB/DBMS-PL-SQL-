ACCEPT B PROMPT 'Enter the breadth:';
ACCEPT H PROMPT 'Enter the height:';
DECLARE
B NUMBER := &B;
H NUMBER := &H;
AREA NUMBER;
BEGIN
AREA := B*H*0.5;
DBMS_OUTPUT.PUT_LINE('Area is '|| AREA);
END;
/