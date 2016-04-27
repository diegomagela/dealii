// ---------------------------------------------------------------------
//
// Copyright (C) 2016 by the deal.II authors
//
// This file is part of the deal.II library.
//
// The deal.II library is free software; you can use it, redistribute
// it, and/or modify it under the terms of the GNU Lesser General
// Public License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
// The full text of the license can be found in the file LICENSE at
// the top level of the deal.II distribution.
//
// ---------------------------------------------------------------------

#ifndef dealii__function_cspline_h
#define dealii__function_cspline_h

#include <deal.II/base/config.h>

#ifdef DEAL_II_WITH_GSL
#include <deal.II/base/function.h>
#include <deal.II/base/point.h>
#include <gsl/gsl_spline.h>

DEAL_II_NAMESPACE_OPEN

namespace Functions
{
  DeclException3 (ExcCSplineOrder,
                  int,
                  double,
                  double,
                  << "CSpline: x[" << arg1 << "] = "<< arg2 <<" >= x["<<(arg1+1)<<" = "<<arg3
                 );

  DeclException3 (ExcCSplineRange,
                  double,
                  double,
                  double,
                  << "CSpline: " << arg1 << " is not in ["<< arg2<<";"<<arg3<<"]."
                 );
  /**
   * The cubic spline function using GNU Scientific Library.
   * The resulting curve is piecewise cubic on each interval, with matching first
   * and second derivatives at the supplied data-points. The second derivative
   * is chosen to be zero at the first point and last point.
   *
   * @note This function is only implemented for dim==1 .
   *
   * @author Denis Davydov
   * @date 2016
   */
  template <int dim>
  class CSpline : public Function<dim>
  {
  public:
    /**
     * Constructor which should be provided with a set of points at which interpolation is to be done @p x
     * and a set of function values @p f .
     */
    CSpline(const std::vector<double> &x,
            const std::vector<double> &f);

    /**
     * Virtual destructor.
     */
    virtual ~CSpline();

    virtual double value (const Point<dim> &point,
                          const unsigned int component = 0) const;

    virtual Tensor<1,dim> gradient (const Point<dim>   &p,
                                    const unsigned int  component = 0) const;

    std::size_t memory_consumption () const;

  private:
    /**
     * Points at which interpolation is provided
     */
    const std::vector<double> x;

    /**
     * Values of the function at interpolation points
     */
    const std::vector<double> y;

    /**
     * Maximum allowed value of x
     */
    const double x_max;

    /**
     * Minimum allowed value of x
     */
    const double x_min;

    /**
     * GSL accelerator for spline interpolation
     */
    gsl_interp_accel *acc;

    /**
     * GSL cubic spline object
     */
    gsl_spline *cspline;
  };
}

DEAL_II_NAMESPACE_CLOSE

#endif

#endif

