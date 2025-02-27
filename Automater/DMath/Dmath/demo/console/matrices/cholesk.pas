{ ******************************************************************
  This program computes the Cholesky factorization of a symmetric
  positive definite matrix. The matrix is stored in a data file with
  the following structure :

    Line 1             : dimension of the matrix (N)
    Lines 2 to (N + 1) : matrix

  The file MATRIX4.DAT is an example data file with N = 3
  ****************************************************************** }

program cholesk;

uses
{$IFDEF USE_DLL}
  dmath;
{$ELSE}
  utypes, ucholesk;
{$ENDIF}    

var
  A, L : TMatrix;  { Matrix and its Cholesky factor }
  B    : TMatrix;  { Product L * L' }
  N    : Integer;  { Dimension of matrix }

procedure ReadMatrix(FileName : String; var A : TMatrix;
                     var N : Integer);
{ ------------------------------------------------------------------
  Reads matrix from file. Note that A is passed as a VAR parameter
  because it is dimensioned inside the procedure.
  ------------------------------------------------------------------ }
var
  F    : Text;     { Data file }
  I, J : Integer;  { Loop variables }
begin
  Assign(F, FileName);
  Reset(F);
  Read(F, N);
  DimMatrix(A, N, N);
  for I := 1 to N do
    for J := 1 to N do
      Read(F, A[I,J]);
  Close(F);
end;

procedure WriteMatrix(Title : String; A : TMatrix; N : Integer);
{ ------------------------------------------------------------------
  Writes matrix on screen
  ------------------------------------------------------------------ }
var
  I, J : Integer;
begin
  WriteLn(#10, Title, ' :', #10);
  for I := 1 to N do
    begin
      for J := 1 to N do
        Write(A[I,J]:12:6);
      WriteLn;
    end;
end;

procedure MulMat(L : TMatrix; N : Integer; B : TMatrix);
{ ------------------------------------------------------------------
  Computes the product B = L * L'
  ------------------------------------------------------------------ }
var
  I, J, K : Integer;
  M       : Float;
begin
  for I := 1 to N do
    for J := 1 to I do
      begin
        M := 0.0;
        for K := 1 to J do
          M := M + L[I,K] * L[J,K];
        B[I,J] := M;
        if I <> J then
          B[J,I] := M;
      end;
end;

begin
  { Read matrix A from file }
  ReadMatrix('matrix4.dat', A, N);
  WriteMatrix('Original matrix', A, N);

  { Dimension other matrices }
  DimMatrix(L, N, N);
  DimMatrix(B, N, N);

  { Perform Cholesky factorization, then compute the product L * L'
    which must be equal to the original matrix }
  Cholesky(A, L, 1, N);

  case MathErr of
    MatOk    : begin
                 WriteMatrix('Cholesky factor (L)', L, N);
                 MulMat(L, N, B);
                 WriteMatrix('Product L * L''', B, N);
               end;
    MatNotPD : Write('Matrix not positive definite');
  end;
  WriteLn;
end.
