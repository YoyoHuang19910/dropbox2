/*
 * 版权属于：yitter(yitter@126.com)
 * 开源地址：https://github.com/yitter/idgenerator
 */
package com.github.yitter.contract;

public interface IIdGenerator {
    long newLong() throws IdGeneratorException;
}
