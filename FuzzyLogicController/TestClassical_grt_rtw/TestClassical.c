/*
 * TestClassical.c
 *
 * Code generation for model "TestClassical".
 *
 * Model version              : 1.10
 * Simulink Coder version : 8.14 (R2018a) 06-Feb-2018
 * C source code generated on : Thu Aug  4 13:49:30 2022
 *
 * Target selection: grt.tlc
 * Note: GRT includes extra infrastructure and instrumentation for prototyping
 * Embedded hardware selection: Intel->x86-64 (Windows64)
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#include "TestClassical.h"
#include "TestClassical_private.h"

/* Block signals (default storage) */
B_TestClassical_T TestClassical_B;

/* Continuous states */
X_TestClassical_T TestClassical_X;

/* Block states (default storage) */
DW_TestClassical_T TestClassical_DW;

/* Real-time model */
RT_MODEL_TestClassical_T TestClassical_M_;
RT_MODEL_TestClassical_T *const TestClassical_M = &TestClassical_M_;

/*
 * This function updates continuous states using the ODE4 fixed-step
 * solver algorithm
 */
static void rt_ertODEUpdateContinuousStates(RTWSolverInfo *si )
{
  time_T t = rtsiGetT(si);
  time_T tnew = rtsiGetSolverStopTime(si);
  time_T h = rtsiGetStepSize(si);
  real_T *x = rtsiGetContStates(si);
  ODE4_IntgData *id = (ODE4_IntgData *)rtsiGetSolverData(si);
  real_T *y = id->y;
  real_T *f0 = id->f[0];
  real_T *f1 = id->f[1];
  real_T *f2 = id->f[2];
  real_T *f3 = id->f[3];
  real_T temp;
  int_T i;
  int_T nXc = 3;
  rtsiSetSimTimeStep(si,MINOR_TIME_STEP);

  /* Save the state values at time t in y, we'll use x as ynew. */
  (void) memcpy(y, x,
                (uint_T)nXc*sizeof(real_T));

  /* Assumes that rtsiSetT and ModelOutputs are up-to-date */
  /* f0 = f(t,y) */
  rtsiSetdX(si, f0);
  TestClassical_derivatives();

  /* f1 = f(t + (h/2), y + (h/2)*f0) */
  temp = 0.5 * h;
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (temp*f0[i]);
  }

  rtsiSetT(si, t + temp);
  rtsiSetdX(si, f1);
  TestClassical_step();
  TestClassical_derivatives();

  /* f2 = f(t + (h/2), y + (h/2)*f1) */
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (temp*f1[i]);
  }

  rtsiSetdX(si, f2);
  TestClassical_step();
  TestClassical_derivatives();

  /* f3 = f(t + h, y + h*f2) */
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + (h*f2[i]);
  }

  rtsiSetT(si, tnew);
  rtsiSetdX(si, f3);
  TestClassical_step();
  TestClassical_derivatives();

  /* tnew = t + h
     ynew = y + (h/6)*(f0 + 2*f1 + 2*f2 + 2*f3) */
  temp = h / 6.0;
  for (i = 0; i < nXc; i++) {
    x[i] = y[i] + temp*(f0[i] + 2.0*f1[i] + 2.0*f2[i] + f3[i]);
  }

  rtsiSetSimTimeStep(si,MAJOR_TIME_STEP);
}

/* Model step function */
void TestClassical_step(void)
{
  real_T rtb_Sum_d;
  if (rtmIsMajorTimeStep(TestClassical_M)) {
    /* set solver stop time */
    if (!(TestClassical_M->Timing.clockTick0+1)) {
      rtsiSetSolverStopTime(&TestClassical_M->solverInfo,
                            ((TestClassical_M->Timing.clockTickH0 + 1) *
        TestClassical_M->Timing.stepSize0 * 4294967296.0));
    } else {
      rtsiSetSolverStopTime(&TestClassical_M->solverInfo,
                            ((TestClassical_M->Timing.clockTick0 + 1) *
        TestClassical_M->Timing.stepSize0 + TestClassical_M->Timing.clockTickH0 *
        TestClassical_M->Timing.stepSize0 * 4294967296.0));
    }
  }                                    /* end MajorTimeStep */

  /* Update absolute time of base rate at minor time step */
  if (rtmIsMinorTimeStep(TestClassical_M)) {
    TestClassical_M->Timing.t[0] = rtsiGetT(&TestClassical_M->solverInfo);
  }

  /* TransferFcn: '<Root>/Transfer Fcn' */
  TestClassical_B.TransferFcn = 0.0;
  TestClassical_B.TransferFcn += TestClassical_P.TransferFcn_C *
    TestClassical_X.TransferFcn_CSTATE;
  if (rtmIsMajorTimeStep(TestClassical_M)) {
    /* DiscretePulseGenerator: '<Root>/Pulse Generator' */
    TestClassical_B.PulseGenerator = (TestClassical_DW.clockTickCounter <
      TestClassical_P.PulseGenerator_Duty) && (TestClassical_DW.clockTickCounter
      >= 0) ? TestClassical_P.PulseGenerator_Amp : 0.0;
    if (TestClassical_DW.clockTickCounter >=
        TestClassical_P.PulseGenerator_Period - 1.0) {
      TestClassical_DW.clockTickCounter = 0;
    } else {
      TestClassical_DW.clockTickCounter++;
    }

    /* End of DiscretePulseGenerator: '<Root>/Pulse Generator' */
  }

  /* Sum: '<Root>/Sum' */
  rtb_Sum_d = TestClassical_B.PulseGenerator - TestClassical_B.TransferFcn;

  /* Gain: '<S1>/Integral Gain' */
  TestClassical_B.IntegralGain = TestClassical_P.PIDController_I * rtb_Sum_d;

  /* Sum: '<Root>/Sum1' incorporates:
   *  Gain: '<S1>/Proportional Gain'
   *  Integrator: '<S1>/Integrator'
   *  StateSpace: '<S2>/State Space'
   *  Sum: '<S1>/Sum'
   */
  TestClassical_B.Sum1 = (TestClassical_P.PIDController_P * rtb_Sum_d +
    TestClassical_X.Integrator_CSTATE) + (TestClassical_P.StateSpace_C *
    TestClassical_X.StateSpace_CSTATE + TestClassical_P.StateSpace_D *
    TestClassical_B.PulseGenerator);
  if (rtmIsMajorTimeStep(TestClassical_M)) {
    /* Matfile logging */
    rt_UpdateTXYLogVars(TestClassical_M->rtwLogInfo, (TestClassical_M->Timing.t));
  }                                    /* end MajorTimeStep */

  if (rtmIsMajorTimeStep(TestClassical_M)) {
    /* signal main to stop simulation */
    {                                  /* Sample time: [0.0s, 0.0s] */
      if ((rtmGetTFinal(TestClassical_M)!=-1) &&
          !((rtmGetTFinal(TestClassical_M)-(((TestClassical_M->Timing.clockTick1
               +TestClassical_M->Timing.clockTickH1* 4294967296.0)) * 3.0)) >
            (((TestClassical_M->Timing.clockTick1+
               TestClassical_M->Timing.clockTickH1* 4294967296.0)) * 3.0) *
            (DBL_EPSILON))) {
        rtmSetErrorStatus(TestClassical_M, "Simulation finished");
      }
    }

    rt_ertODEUpdateContinuousStates(&TestClassical_M->solverInfo);

    /* Update absolute time for base rate */
    /* The "clockTick0" counts the number of times the code of this task has
     * been executed. The absolute time is the multiplication of "clockTick0"
     * and "Timing.stepSize0". Size of "clockTick0" ensures timer will not
     * overflow during the application lifespan selected.
     * Timer of this task consists of two 32 bit unsigned integers.
     * The two integers represent the low bits Timing.clockTick0 and the high bits
     * Timing.clockTickH0. When the low bit overflows to 0, the high bits increment.
     */
    if (!(++TestClassical_M->Timing.clockTick0)) {
      ++TestClassical_M->Timing.clockTickH0;
    }

    TestClassical_M->Timing.t[0] = rtsiGetSolverStopTime
      (&TestClassical_M->solverInfo);

    {
      /* Update absolute timer for sample time: [3.0s, 0.0s] */
      /* The "clockTick1" counts the number of times the code of this task has
       * been executed. The resolution of this integer timer is 3.0, which is the step size
       * of the task. Size of "clockTick1" ensures timer will not overflow during the
       * application lifespan selected.
       * Timer of this task consists of two 32 bit unsigned integers.
       * The two integers represent the low bits Timing.clockTick1 and the high bits
       * Timing.clockTickH1. When the low bit overflows to 0, the high bits increment.
       */
      TestClassical_M->Timing.clockTick1++;
      if (!TestClassical_M->Timing.clockTick1) {
        TestClassical_M->Timing.clockTickH1++;
      }
    }
  }                                    /* end MajorTimeStep */
}

/* Derivatives for root system: '<Root>' */
void TestClassical_derivatives(void)
{
  XDot_TestClassical_T *_rtXdot;
  _rtXdot = ((XDot_TestClassical_T *) TestClassical_M->derivs);

  /* Derivatives for TransferFcn: '<Root>/Transfer Fcn' */
  _rtXdot->TransferFcn_CSTATE = 0.0;
  _rtXdot->TransferFcn_CSTATE += TestClassical_P.TransferFcn_A *
    TestClassical_X.TransferFcn_CSTATE;
  _rtXdot->TransferFcn_CSTATE += TestClassical_B.Sum1;

  /* Derivatives for Integrator: '<S1>/Integrator' */
  _rtXdot->Integrator_CSTATE = TestClassical_B.IntegralGain;

  /* Derivatives for StateSpace: '<S2>/State Space' */
  _rtXdot->StateSpace_CSTATE = 0.0;
  _rtXdot->StateSpace_CSTATE += TestClassical_P.StateSpace_A *
    TestClassical_X.StateSpace_CSTATE;
  _rtXdot->StateSpace_CSTATE += TestClassical_P.StateSpace_B *
    TestClassical_B.PulseGenerator;
}

/* Model initialize function */
void TestClassical_initialize(void)
{
  /* Registration code */

  /* initialize non-finites */
  rt_InitInfAndNaN(sizeof(real_T));

  /* initialize real-time model */
  (void) memset((void *)TestClassical_M, 0,
                sizeof(RT_MODEL_TestClassical_T));

  {
    /* Setup solver object */
    rtsiSetSimTimeStepPtr(&TestClassical_M->solverInfo,
                          &TestClassical_M->Timing.simTimeStep);
    rtsiSetTPtr(&TestClassical_M->solverInfo, &rtmGetTPtr(TestClassical_M));
    rtsiSetStepSizePtr(&TestClassical_M->solverInfo,
                       &TestClassical_M->Timing.stepSize0);
    rtsiSetdXPtr(&TestClassical_M->solverInfo, &TestClassical_M->derivs);
    rtsiSetContStatesPtr(&TestClassical_M->solverInfo, (real_T **)
                         &TestClassical_M->contStates);
    rtsiSetNumContStatesPtr(&TestClassical_M->solverInfo,
      &TestClassical_M->Sizes.numContStates);
    rtsiSetNumPeriodicContStatesPtr(&TestClassical_M->solverInfo,
      &TestClassical_M->Sizes.numPeriodicContStates);
    rtsiSetPeriodicContStateIndicesPtr(&TestClassical_M->solverInfo,
      &TestClassical_M->periodicContStateIndices);
    rtsiSetPeriodicContStateRangesPtr(&TestClassical_M->solverInfo,
      &TestClassical_M->periodicContStateRanges);
    rtsiSetErrorStatusPtr(&TestClassical_M->solverInfo, (&rtmGetErrorStatus
      (TestClassical_M)));
    rtsiSetRTModelPtr(&TestClassical_M->solverInfo, TestClassical_M);
  }

  rtsiSetSimTimeStep(&TestClassical_M->solverInfo, MAJOR_TIME_STEP);
  TestClassical_M->intgData.y = TestClassical_M->odeY;
  TestClassical_M->intgData.f[0] = TestClassical_M->odeF[0];
  TestClassical_M->intgData.f[1] = TestClassical_M->odeF[1];
  TestClassical_M->intgData.f[2] = TestClassical_M->odeF[2];
  TestClassical_M->intgData.f[3] = TestClassical_M->odeF[3];
  TestClassical_M->contStates = ((X_TestClassical_T *) &TestClassical_X);
  rtsiSetSolverData(&TestClassical_M->solverInfo, (void *)
                    &TestClassical_M->intgData);
  rtsiSetSolverName(&TestClassical_M->solverInfo,"ode4");
  rtmSetTPtr(TestClassical_M, &TestClassical_M->Timing.tArray[0]);
  rtmSetTFinal(TestClassical_M, 9.0);
  TestClassical_M->Timing.stepSize0 = 3.0;

  /* Setup for data logging */
  {
    static RTWLogInfo rt_DataLoggingInfo;
    rt_DataLoggingInfo.loggingInterval = NULL;
    TestClassical_M->rtwLogInfo = &rt_DataLoggingInfo;
  }

  /* Setup for data logging */
  {
    rtliSetLogXSignalInfo(TestClassical_M->rtwLogInfo, (NULL));
    rtliSetLogXSignalPtrs(TestClassical_M->rtwLogInfo, (NULL));
    rtliSetLogT(TestClassical_M->rtwLogInfo, "tout");
    rtliSetLogX(TestClassical_M->rtwLogInfo, "");
    rtliSetLogXFinal(TestClassical_M->rtwLogInfo, "");
    rtliSetLogVarNameModifier(TestClassical_M->rtwLogInfo, "rt_");
    rtliSetLogFormat(TestClassical_M->rtwLogInfo, 4);
    rtliSetLogMaxRows(TestClassical_M->rtwLogInfo, 0);
    rtliSetLogDecimation(TestClassical_M->rtwLogInfo, 1);
    rtliSetLogY(TestClassical_M->rtwLogInfo, "");
    rtliSetLogYSignalInfo(TestClassical_M->rtwLogInfo, (NULL));
    rtliSetLogYSignalPtrs(TestClassical_M->rtwLogInfo, (NULL));
  }

  /* block I/O */
  (void) memset(((void *) &TestClassical_B), 0,
                sizeof(B_TestClassical_T));

  /* states (continuous) */
  {
    (void) memset((void *)&TestClassical_X, 0,
                  sizeof(X_TestClassical_T));
  }

  /* states (dwork) */
  (void) memset((void *)&TestClassical_DW, 0,
                sizeof(DW_TestClassical_T));

  /* Matfile logging */
  rt_StartDataLoggingWithStartTime(TestClassical_M->rtwLogInfo, 0.0,
    rtmGetTFinal(TestClassical_M), TestClassical_M->Timing.stepSize0,
    (&rtmGetErrorStatus(TestClassical_M)));

  /* Start for DiscretePulseGenerator: '<Root>/Pulse Generator' */
  TestClassical_DW.clockTickCounter = 0;

  /* InitializeConditions for TransferFcn: '<Root>/Transfer Fcn' */
  TestClassical_X.TransferFcn_CSTATE = 0.0;

  /* InitializeConditions for Integrator: '<S1>/Integrator' */
  TestClassical_X.Integrator_CSTATE = TestClassical_P.Integrator_IC;

  /* InitializeConditions for StateSpace: '<S2>/State Space' */
  TestClassical_X.StateSpace_CSTATE =
    TestClassical_P.StateSpace_InitialCondition;
}

/* Model terminate function */
void TestClassical_terminate(void)
{
  /* (no terminate code required) */
}
