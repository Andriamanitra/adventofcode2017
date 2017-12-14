MODULE sharedVars
    integer, dimension(0:100) :: layers
END MODULE sharedVars

PROGRAM day13
    USE sharedVars

    ! IMPLICIT NONE makes sure all variables are declared
    IMPLICIT NONE

    ! All type declaration statements should be before executable statements
    logical :: caught = .FALSE.
    integer :: i
    integer :: j
    integer :: g
    character(len=12) :: word

    OPEN(unit = 1, file = "13-input.txt")

    ! Initialize variables
    DO i = 0,100
        layers(i) = 0
    END DO

    ! Read layer ranges from file
    DO i = 0,100
        READ(1,*,end=10) word, g ! Jumps to label 10 on EOF
        READ(word(1:INDEX(word, ":")-1),*) j
        ! j = layer index; g = layer range
        layers(j) = g
    END DO
10  CLOSE(1)

    DO i = 0,50000000
        CALL tryWithDelay(i, caught)
        IF (.NOT. caught) THEN
            PRINT 100, i
            100 FORMAT("Avoided getting caught with delay ", i0)
            EXIT
        END IF
    END DO

END PROGRAM day13

SUBROUTINE tryWithDelay(x, caught)
    USE sharedVars

    IMPLICIT NONE

    integer, intent(in) :: x
    logical, intent(out) :: caught
    integer :: i

    caught = .FALSE.
    ! Sadly the cool code from first part with the guards walking and all
    ! is practically useless in the second part because of performance
    ! constraints so this part uses some boring modulo calculations to
    ! see whether there was a collision with the guard.
    DO i = 0,100
        IF (layers(i) > 0 .AND. MODULO(x+i, 2*(layers(i)-1)) == 0) THEN
            caught = .TRUE.
            EXIT
        END IF
    END DO
END SUBROUTINE tryWithDelay