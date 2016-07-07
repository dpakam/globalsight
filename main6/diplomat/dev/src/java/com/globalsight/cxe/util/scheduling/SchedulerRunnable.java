/**
 *  Copyright 2009 Welocalize, Inc. 
 *  
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  
 *  You may obtain a copy of the License at 
 *  http://www.apache.org/licenses/LICENSE-2.0
 *  
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *  
 */
package com.globalsight.cxe.util.scheduling;

import java.util.Map;

public class SchedulerRunnable implements Runnable
{
    private Map<String, Object> m_data;

    public SchedulerRunnable(Map<String, Object> data)
    {
        m_data = data;
    }

    @Override
    public void run()
    {
        SchedulerUtil.performSchedulingAction(getData());
    }

    private Map<String, Object> getData()
    {
        return m_data;
    }
}