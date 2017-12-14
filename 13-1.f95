MODULE sharedVars
    integer, dimension(0:100) :: layers
    integer, dimension(0:100) :: guards
    integer, dimension(0:100) :: guardDirection
END MODULE sharedVars

PROGRAM day13
    USE sharedVars
    ! IMPLICIT NONE makes sure all variables are declared
    IMPLICIT NONE
    ! All type declaration statements should be before executable statements
    
    integer :: i
    integer :: j
    integer :: g
    integer :: severity
    character(len=12) :: word

    OPEN(unit = 1, file = "13-input.txt")

    ! Initialize variables
    severity = 0
    DO i = 0,100
        layers(i) = 0
        guards(i) = 0
        guardDirection(i) = 1
    END DO

    ! Read layer ranges from file
    DO i = 0,100
        READ(1,*,end=10) word, g ! Jumps to label 10 on EOF
        READ(word(1:INDEX(word, ":")-1),*) j
        ! j = layer index; g = layer range
        layers(j) = g
    END DO
10  CLOSE(1)

    ! Place guards on layers that aren't 0 (empty layers)
    DO i = 0,100
        IF (layers(i) > 0) THEN
            guards(i) = 1
        END IF
    END DO

    ! Walk through the firewall
    DO i = 0,100
        IF (guards(i) == 1) THEN ! Caught
            severity = severity + i*layers(i)
        END IF
        CALL guardsWalk
    END DO

    PRINT 100, severity
    100 FORMAT("Severity of the trip through the firewall was ", i0)

END PROGRAM day13

SUBROUTINE guardsWalk
    USE sharedVars
    IMPLICIT NONE
    integer :: i
    integer :: g
    DO i = 0,100
        IF (guards(i) > 0) THEN ! There is a guard on this layer
            ! Check if guard would go outside the layer range
            ! and reverse direction if needed
            g = guards(i) + guardDirection(i)
            IF (g > layers(i) .OR. g < 1) THEN
                guardDirection(i) = -guardDirection(i)
            END IF
            guards(i) = guards(i) + guardDirection(i)
        END IF
    END DO
END SUBROUTINE guardsWalk