/* -----------------------------------------------------------------------------
 * enums.swg
 *
 * Include this file in order for C/C++ enums to be wrapped by proper Java enums.
 * Note that the JNI layer handles the enum as an int. The Java enum has extra
 * code generated to store the C++ int value. This is required for C++ enums that
 * specify a value for the enum item, as native Java enums do not support this.
 * ----------------------------------------------------------------------------- */

// const enum SWIGTYPE & typemaps
%typemap(jni) const enum SWIGTYPE & "int"
%typemap(jtype) const enum SWIGTYPE & "int"
%typemap(jstype) const enum SWIGTYPE & "$*javaclassname"

%typemap(in) const enum SWIGTYPE & ($*1_ltype temp)
%{ temp = ($*1_ltype)$input; 
   $1 = &temp; %}
%typemap(out) const enum SWIGTYPE &  %{ $result = (jint)*$1; %}

%typemap(directorout,warning=SWIGWARN_TYPEMAP_THREAD_UNSAFE_MSG) const enum SWIGTYPE &
%{ static $*1_ltype temp = ($*1_ltype)$input; 
   $result = &temp; %}
%typemap(directorin, descriptor="L$packagepath/$*javaclassname;") const enum SWIGTYPE & "$input = (jint)$1;"
%typemap(javadirectorin) const enum SWIGTYPE & "$*javaclassname.swigToEnum($jniinput)"
%typemap(javadirectorout) const enum SWIGTYPE & "($javacall).swigValue()"

%typecheck(SWIG_TYPECHECK_POINTER) const enum SWIGTYPE & ""

%typemap(throws) const enum SWIGTYPE &
%{ (void)$1;
   SWIG_JavaThrowException(jenv, SWIG_JavaRuntimeException, "C++ $1_type exception thrown"); %}

%typemap(javain) const enum SWIGTYPE & "$javainput.swigValue()"
%typemap(javaout) const enum SWIGTYPE & {
    return $*javaclassname.swigToEnum($jnicall);
  }


// enum SWIGTYPE typemaps
%typemap(jni) enum SWIGTYPE "int"
%typemap(jtype) enum SWIGTYPE "int"
%typemap(jstype) enum SWIGTYPE "$javaclassname"

%typemap(in) enum SWIGTYPE  %{ $1 = ($1_ltype)$input; %}
%typemap(out) enum SWIGTYPE  %{ $result = (jint)$1; %}

%typemap(directorout) enum SWIGTYPE  %{ $result = ($1_ltype)$input; %}
%typemap(directorin, descriptor="L$packagepath/$javaclassname;") enum SWIGTYPE "$input = (jint) $1;"
%typemap(javadirectorin) enum SWIGTYPE "$javaclassname.swigToEnum($jniinput)"
%typemap(javadirectorout) enum SWIGTYPE "($javacall).swigValue()"

%typecheck(SWIG_TYPECHECK_POINTER) enum SWIGTYPE ""

%typemap(throws) enum SWIGTYPE
%{ (void)$1;
   SWIG_JavaThrowException(jenv, SWIG_JavaRuntimeException, "C++ $1_type exception thrown"); %}

%typemap(javain) enum SWIGTYPE "$javainput.swigValue()"
%typemap(javaout) enum SWIGTYPE {
    return $javaclassname.swigToEnum($jnicall);
  }

%typemap(javaclassmodifiers) enum SWIGTYPE "actual enum class"
%typemap(expectclassmodifiers) enum SWIGTYPE "$expect enum class"
%typemap(javabase)           enum SWIGTYPE ""
%typemap(javacode)           enum SWIGTYPE ""
%typemap(javaimports)        enum SWIGTYPE ""
%typemap(javainterfaces)     enum SWIGTYPE ""

/*
 * SwigNext static inner class used instead of a static int as static fields cannot be accessed from enum initialisers.
 * The swigToEnum method is used to find the Java enum from a C++ enum integer value. The default one here takes 
 * advantage of the fact that most enums do not have initial values specified, so the lookup is fast. If initial
 * values are specified then a lengthy linear search through all possible enums might occur. Specific typemaps could be
 * written to possibly optimise this lookup by taking advantage of characteristics peculiar to the targeted enum.
 */
%typemap(javabody) enum SWIGTYPE %{
  public final fun swigValue():Int {
    val t = $javaclassname; // Force initialization of companion object
    return swigValue.value;
  }

  @Suppress("unused")
  private constructor() {
  }

  @Suppress("unused")
  private constructor(swigValue: Int) {
    this.swigValue.value = swigValue
    this.swigValueSet.value = 1
  }

  @Suppress("unused")
  private constructor(swigEnum: $javaclassname) {
    this.swigValue.value = swigEnum.swigValue.value
  }

  private val swigValue = kotlin.native.concurrent.AtomicInt(0)
  private val swigValueSet = kotlin.native.concurrent.AtomicInt(0)

  companion object {

    val swigValues = $javaclassname.values();

    init{
      var next = 0
      for (swigEnum in swigValues){
        if (swigEnum.swigValueSet.value != 0){
          next = swigEnum.swigValue.value
        }else{
          swigEnum.swigValue.value = next
        }
        next++
      }
    }
    
    public fun swigToEnum(swigValue: Int): $javaclassname {
      if (swigValue < swigValues.size && swigValue >= 0 && swigValues[swigValue].swigValue.value == swigValue)
        return swigValues[swigValue]
      for (swigEnum in swigValues)
        if (swigEnum.swigValue.value == swigValue)
          return swigEnum
      throw IllegalArgumentException("No enum " + $javaclassname + " with value " + swigValue)
    }

  }
%}

%javaenum(proper);
