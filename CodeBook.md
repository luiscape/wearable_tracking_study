Code Book for 'Wearable Study Data'
==================================

The datasets `` is a [tidy version](Hickman Tidy paper link here) of the original dataset available. For a complete version of the dataset, please refer to the original datasets available here.

After selcting only the Mean and Standard Deviation measurements we are left with 79 variables to work with. The variables have the following naming structure:

          1 2   3    4     5
          ↓ ↓   ↓    ↓     ↓
          tBodyGyro.mean...X



Based on that naming structure I created 5 variables:

- **1**: Type of signal. It can be either a Time signal or [Fast Fourier Transform](FFT transformation link here) signal (to clear noise).
-- `Time`: The time signal when the activity was recorded.
-- `Fast Fourier Transform`: Transformation performed to reduce noise.
- **2**: Type of capture collected by the sensor: Body or Gravity.
-- `Body`: When the measurement is about the force made by the *body* of the subject.
-- `Gravity`:When the measurement is about the force made by *gravity*.
- **3**: Type of measurement by one of the two sensors, Accelerometer or Gyroscope. The types can be Jerk or Magnitude, or a combination of both.
-- `Accelerometer`: when measurement is done by the accelerometer.
-- `Accelerometer Jerk`: when measurement is done by the accelerometer in a jerk motion.
-- `Accelerometer Jerk Magnitude`: when measurement is about the magnitude of the jerk motion in the accelerometer.
-- `Accelerometer Magnitude `: when measurement is about the magnitude of the accelerometer's measurements.
-- `Gyroscope`: measurement about the motion of the gyroscope.
-- `Gyroscope Jerk`: measurement about the movement of the gyroscope in jerk motion.
-- `Gyroscope Magnitude`: when measurement is about the magnitude of the gyroscope's measurements.
- **4**: Type of measurement. In this dataset we have only left the variables that measure mean and standard deviation.
--`Mean`: the mean of the measurement.
--`Mean Frequency`: the frequency of the mean mean of the measurement.
--`Standard Deviation`: the standard deviation of the measurement.
- **5**: Type of axis the variable describes.
--`X`: measurement from the X axis.
--`Y`: measurement from the Y axis.
--`Z`: measurement from the Z axis.


I also added two other variables to identify what activity was being performed and to be able to distinguish between the `test` and the `train` subjects:

- **6**: Label. That explains what subject group is the measurement about. 
--`train`: measurement about train subjects.
--`test`: measurement about test subjects.
- **7**: Activity. That explains the type of activity being performed. Activities can be:
--`LAYING`
--`SITTING`
--`STANDING`
--`WALKING`
--`WALKING_DOWNSTAIRS`
--`WALKING_UPSTAIRS`
