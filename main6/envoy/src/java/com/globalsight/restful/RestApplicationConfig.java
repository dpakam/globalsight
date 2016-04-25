/**
 * Copyright 2009 Welocalize, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License.
 *
 * You may obtain a copy of the License at
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 *
 */

package com.globalsight.restful;

import java.util.HashSet;
import java.util.Set;

import javax.ws.rs.ApplicationPath;
import javax.ws.rs.core.Application;

import com.globalsight.restful.tm.TmResource;
import com.globalsight.restful.tmprofile.TmProfileResource;

@ApplicationPath("/restfulServices")
public class RestApplicationConfig extends Application
{
    private Set<Object> singletons = new HashSet<Object>();

    // Register your resource classes here
    public RestApplicationConfig()
    {
        singletons.add(new TmResource());

        singletons.add(new TmProfileResource());

        // This is a "helper" resource, will be not published.
        singletons.add(new LoginResource());
    }

    @Override
    public Set<Object> getSingletons()
    {
        return singletons;
    }
}
