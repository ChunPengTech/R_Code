cnuse data.xlsx, clear

winsor2 lnc, cut(1 99) replace
winsor2 lnc2, cut(4 96) replace
winsor2 indifi lnc1, cut(5 95) replace

tab id, gen(iid) // 生成个体和时间虚拟变量
tab year, gen(iyear)

local control_variable is CPI edu fdl con

****************** sobel *******************

// quietly 表示不显示逐步回归的结果
sgmediation lnc, mv(lnincome) iv(indifi) cv($control_variable iid1-iid31 iyear1-iyear10) quietly

// 等价于
sgmediation3 lnc, mv(lnincome) iv(indifi) cv($control_variable) quietly

****************** reghdfe boot *******************

* 定义计算中介效应的程序
capture program drop compute_med
program define compute_med, rclass
    // 1. x - m  vce(cluster id) 看情况加
    reghdfe lnincome indifi $control_variable  ///
        , absorb(id year)
    local a_M = _b[indifi]

    // 2. x m - y
    reghdfe lnc indifi lnincome $control_variable ///
        , absorb(id year)
    local b_YM = _b[lnincome]
    local direct_effect = _b[indifi]

    // 3. a*b
    return scalar indirect = `a_M' * `b_YM'
    return scalar direct = `direct_effect'
end

* 运行Bootstrap
bootstrap indirect=r(indirect) direct=r(direct), ///
    reps(100) seed(123) strata(id): compute_med
estat bootstrap, all

// 等价于
bootstrap indirect=r(ind_eff) direct=r(dir_eff), reps(100) seed(123): sgmediation3 lnc, mv(lnincome) iv(indifi) cv($control_variable)
estat bootstrap, all